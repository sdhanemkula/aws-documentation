# Glue Job Parameter Examples

The following document outlines 'how' glue submits the job to spark given your configuration.

The example was taken from a job run cloud watch logs and assumes a 15 DPU with the configuration params

| param | value |
| -- | -- |
|--conf  | spark.executor.memory=8g  |
|--SRC_TABLE   | policy_data  |
|--SRC_DATABASE| dev_product_raw|


```
# Base glue generated stuff (note the maxExecutors based on 15 dpu (15*2 - 2))
--conf spark.hadoop.yarn.resourcemanager.connect.max-wait.ms=60000
--conf spark.hadoop.fs.defaultFS=hdfs://ip-172-32-38-178.ec2.internal:8020
--conf spark.hadoop.yarn.resourcemanager.address=ip-172-32-38-178.ec2.internal:8032
--conf spark.dynamicAllocation.enabled=true
--conf spark.shuffle.service.enabled=true
--conf spark.dynamicAllocation.minExecutors=1
--conf spark.dynamicAllocation.maxExecutors=28
--conf spark.executor.memory=5g
--conf spark.executor.cores=4
--conf spark.driver.memory=5g
```

```
# Job parameters from job configuration
--job-bookmark-option job-bookmark-disable
--enable-spark-ui true --enable-metrics
--JOB_ID j_23f5043f8aa66e28428058f0351ef73879b9e92600b1edd58600630157ddaa01
--spark-event-logs-path s3://us-east-1-product-raw/spark_logs
--JOB_RUN_ID jr_8214681fc0f03ddbde6df4bac755d69051546e4ef99d9cc40c6613b8caae7426
--job-language scala

# see my job script values
--extra-jars s3://us-east-1-product-code/ra_glue_code/dependent_jars/app-analytics-extractor.jar
--class com.transformation.TransformPolicySummary
--scriptLocation s3://us-east-1-product-code/ra_glue_code/TransformPolicySummary.scala

# see the override by my job here! Note always provides a default first but the 2nd one overrides theirs!
--conf spark.executor.memory=8g

# see the user defined job parameters here
--DEST_S3_LOC s3://us-east-1-product-udl/policy_summary
--SRC_TABLE policy_data
--SRC_DATABASE dev_raw
--JOB_NAME dev-TransformPolicySummary

```
