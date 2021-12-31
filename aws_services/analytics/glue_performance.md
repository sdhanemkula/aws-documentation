# Glue Performance

This file contains all the relevant Glue specific performance information.

## General Glue Information
* DPUs are based on glue version + worker type. Additionally tasks supported are related. Glue 2.0 created new worker types

| worker type | Executor | Tasks | RAM | vCPU|
| -- | -- | -- | -- | -- |
|Standard  | 2 | 4 per executor | 16 | 4 |
|G1.x   | 1  | 8  | 16  | 4  |
|G2.X   | 1  | 16  | 32  | 8  |

* Most jobs can't be scaled by just adding more DPUs! For example product jobs like covers, questions the total number of DPUs must be balanced with how much coalesce is defined within the jobs to ensure each executor is concurrently running the tasks and not just sitting idle.

```
# coalesce of 200 means want 30 DPUs for STANDARD worker type
# STANDARD worker type: 2 executors of 4 tasks each total = 8 tasks
# (30 * 2) - 1 (driver) = 59 executors free to process tasks
# 59 * 4 = 236 available tasks to perform processing (so if only use 100 coalesce most executors only 1/2 processing)
```

* You MUST pay attention to how many S3 GET requests are being performed by concurrent jobs. Failure to properly tune these requests will cause job failures due to "S3 SLOWDOWN" exceptions being thrown by S3 when trying to read files. This is especially problematic in our current design since our RAW risk_assessment folder has approximately 60K objects and thus hitting the S3 limit is easily feasible.

* Glue documentation lists various features to help speed up jobs but none of the following when tested provided any real time savings on the jobs: parquet output committer, group files into partition, useS3ListImplementation

* Can adjust executor memory size to help with garbage collection or OOM issues but it appears to limit the number of executors on the actual DPU definition. For example if set to --conf spark.executor.memory=7g will only get 1 executor for the DPU. Plus with the newer worker types AWS does NOT recommend adjusting these values anymore

* In glue UI if need to specify multiple params must put all in a single --conf key's 'value'!!
```
# example value for --conf having two different conf values tuned
 spark.executor.memory=7g --conf spark.driver.memory=1g
```

* Utilize Job Metrics to see how your job is running to help debug slow running jobs. It's not as ideal as spark history but it does show bottlenecks (e.g. data shuffle, CPU, dpu requests, etc.). Note: that glue 2.x job types do NOT generate DPU metrics only core metrics.
*

## Dynaframe Schema Generation
* Any job that requires glue to read a large number of files to determine schema (e.g. risk_assessments) will incur overhead (e.g. risk assessment jobs have a ~4 minute baseline to 'get/list' the data (I/O operations) so glue can determine all the data types for the dataframe)!

* Can provide Schema to DyanmicFrame to speed up job! Removes 3-4 minutes from some jobs in risk assessment processing!

```
# use the withFrameSchema method to inject the schema so glue doesn't have to figure it out!
val datasource0 = glueContext.getCatalogSource(database = src_db, tableName = src_table, redshiftTmpDir = "",
  transformationContext = "datasource0").getDynamicFrame().withFrameSchema(createSchema)

# example schema definition
def createSchema(): Schema = {
    val newSchema = new Schema(new SchemaBuilder().beginStruct()
      .atomicField("riskId", TypeCode.STRING)
      .atomicField("transmission", TypeCode.INT)
      .beginArrayField("thirdpartyservicerawdata")
        .beginStruct()
          .atomicField("sourceId",TypeCode.STRING)
          .atomicField("base64EncodedData",TypeCode.STRING)
        .endStruct()
      .endArray()
      .endStruct().build())
    return newSchema
  }  
```


## Links

* https://clouderatemp.wpengine.com/blog/2015/03/how-to-tune-your-apache-spark-jobs-part-1/
* https://blog.cloudera.com/how-to-tune-your-apache-spark-jobs-part-2/
