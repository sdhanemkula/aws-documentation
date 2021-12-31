# Glue

## General Guidelines
* Refer to initial AWS Glue Job Limits when starting projects/design (Most limits can be increased but there is an approximate 1 week turnaround to increase limits)

* Avoid hard coding environment specific values for resources like database names, table names, S3 bucket locations, etc. (e.g. SRC_TABLE, SRC_DB, etc.) by using job parameters

 |job param| value |
 | -- | -- |
 |--DEST_S3_LOC|	s3://us-east-1-demo-udl/rx_script_check_details|
 |--SRC_TABLE	|risk_assessments|
 |--SRC_DATABASE|dev_product_raw|

* Ensure schema is defined for all fields when writing to Parquet format!

 ```
 // if creating a default column with no value in a DataFrame
 // make sure to cast it to a valid data type, failure to do so will result in exceptions trying to write to Parquet
 // Unsupported data type NullType.
 val myDF = someDF.withColumn("bmi", lit(null)) // column may NOT have data type if never populated and will crash on write

 val myDF = someDF.withColumn("bmi", lit(null).cast(DoubleType)) // explicit cast forces DF to have schema with DoubleType
 ```

* Design all Glue jobs to isolate glue API dependencies as much as possible to help facilitate easier unit testing. For example, pass DataFrames (if possible) instead of DynamicFrames to method arguments, inject values from glue catalog (e.g. table names, etc.) to dependent methods etc.

* Current glue job submit times for glue version 0.9 and 1.0 within us-east-1 are approx 15 minutes! All new glue jobs should utilize glue 2.0 jobs for faster startup times!

## Supportability
* When debugging glue job failures look into BOTH the logs and the 'error logs' cloud watch log groups. Depending on what type of failure the actual root exception may be found in 'logs' and not 'error logs'.

* Always remember to set a job timeout value to ensure hung jobs eventually stop! Failure to do so will cost extra $$$$

* Utilize MaxRetries property for jobs requiring an automatic retry upon job failure (e.g. job has intermittent failure which typically works on job re-run). When utilizing this property realize that your job may re-run X number times on ANY kind of job failure (e.g. syntax, invalid spark src, etc.).

## Naming Standards
* Glue Job names are global to an AWS account! It is best to prefix a job name with 'env' to make scripting and multi-developer development.
 - For example, dev-TransformRiskAssessment, prod-TransformRiskAssessment, timJ-TransformRiskAssessment

## Costs
* Developer endpoints are charged per hour so they must be created/destroyed in a cost appropriate manner!

* Factor in Glue Costs in all designs
 - For example, it is cheaper to have a single job with 2 dpu take 10 minute vs. the same job with 10 dpu taking 1 minute! (glue has 10 minute minimum on job cost!)

 * When using Triggers in DEV accounts remember to disable them when not actively testing job flows.  Failure to do so will continuously run jobs (e.g. costs $$$$$).

 * Configure relevant log retention policies for Glue logs to save on $$$. Glue job output logs can become quite large thus increasing costs to configure retention policy in each environment to a reasonable value (e.g. 1 month, 2 month, etc.)
