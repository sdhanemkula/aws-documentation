# Glue Update Existing Parquet files

This file contains some information on a potential pattern to update existing parquet files within a glue job.

**Parquet does NOT support update so this is normally an issue and this pattern is a way around this limitation.**

The pattern is basically:
* Read all existing rows from ALL parquet files
* Filter out the 'update' rows from original DF of parquet files (using left_anti JOIN)
* create DF of the 'updates' only
* union the 'updates' DF to the filtered history
* write out new parquet files


## General Pattern example
```
// get original dataframe of data which has modification set in it
val df = selectfields2.toDF()

// do transformation on that 'modified' data set
val assessmentTransformedDF = doTransform(df, spark_session)

// get existing UDL parquet results (minus the ones to transform)
val datasource0 = glueContext.getCatalogSource(database = src_db, tableName = src_table, redshiftTmpDir = "", transformationContext = "questionsDatasource0").getDynamicFrame()    
val existingAssessmentsDF = datasource0.toDF()
    
// now filter out the existing modRaDF items using a left_anti join
val filteredAssessmentsDF = existingAssessmentsDF.join(df, existingAssessmentsDF.col("risk_id") === df.col("riskid") && existingAssessmentsDF.col("transmission") === df.col("transmission"), "left_anti")

var resultDF:DataFrame = null
resultDF = filteredAssessmentsDF.union(assessmentTransformedDF)
// Note: these two lines are HUGE! they force spark to read the old files from S3 and force an action
// to avoid the S3: file not found issue later during the 'overwrite' action.
// https://forums.databricks.com/questions/21830/spark-how-to-simultaneously-read-from-and-write-to.html
resultDF.cache()
resultDF.show(2)

// now write the resultDF back to folder in parquet format
resultDF.coalesce(coalesce_num).write.mode("overwrite").format("parquet").save(output_dir)
```

## Existing errors
* Since spark lazily processes actions, you will encounter an error where one task is trying to read one of the existing parquet files that has been overwritten by other tasks! The only way around this is to 'force' a spark action so that those existing parquet files are in memory BEFORE any writes start. (see .cache from example above)
```
# see something like this in the logs
tor 12: java.io.FileNotFoundException (No such file or directory 's3://us-east-1-dev-product-udl/ra_questions_inc/part-00173-d5f240ff-3c64-4530-b4cd-0c42d1612a27-c000.snappy.parquet'
It is possible the underlying files have been updated. You can explicitly invalidate the cache in Spark by running 'REFRESH TABLE tableName' command in SQL or by recreating the Dataset/DataFrame involved.) [duplicate 2]
```



## Links

* https://forums.databricks.com/questions/21830/spark-how-to-simultaneously-read-from-and-write-to.html
* https://forums.databricks.com/questions/2121/parquet-file-writes-cant-be-read.html
* https://stackoverflow.com/questions/45809152/how-to-refresh-a-table-and-do-it-concurrently/45809353


