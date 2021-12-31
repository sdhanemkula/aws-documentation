# Glue Pushdown Predicates

This file contains all the relevant Glue push down predicate information. This information was obtained via a POC of using glue push down predicates against S3 JSON data only!

## General Glue Pushdown Predicate Information
* Predicates only work for filtering on partitioned data only! (e.g. modified_dt, year, month, etc.)
* Predicates are restriced to any boolean expression IN SPARK SQL ONLY! You can't create a scala function that is evaluated at runtime to create the predicate.
```
# For example to create a last months string you must use the SQL for this
val partitionPredicate =  "modified_dt >= (current_date - interval '6' month)"    
val datasource0 = glueContext.getCatalogSource(database = src_db, tableName = src_table, redshiftTmpDir = "", transformationContext = "datasource0", pushDownPredicate = partitionPredicate).getDynamicFrame()
```


## Glue Predicate Debugging
Glue offers a couple of different options for debugging what glue searched.

* Search Cloudwatch logs for text "Found new partition" to see listing of ALL partitions found/used
```
fields @timestamp, @message
| filter @logStream = 'jr_d7bfb3e57025727b294ee91dadb433a87162c74078600ef2c7b2b9d84777096d' and @message like /Found new partition/
| sort @timestamp desc
| limit 20
```
```	
2021-05-20 17:54:58,595 INFO [main] hadoop.PartitionFilesListerUsingBookmark (FileSystemBookmark.scala:apply(351)): Found new partition DynamicFramePartition(com.amazonaws.services.glue.DynamicRecord@e10482d5,s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2020-12-10,1621360560000) with 436 files
```

* Search Cloudwatch logs for text "Found new partition" within date range
```
fields @timestamp, @message
| filter @logStream = 'jr_d7bfb3e57025727b294ee91dadb433a87162c74078600ef2c7b2b9d84777096d' and @message like /Found new partition/ and @message like /modified_dt=2020-12-04/
| sort @timestamp desc
| limit 20
```
```	
2021-05-20 17:54:58,595 INFO [main] hadoop.PartitionFilesListerUsingBookmark (FileSystemBookmark.scala:apply(351)): Found new partition DynamicFramePartition(com.amazonaws.services.glue.DynamicRecord@e10482d5,s3://us-east-1-prd-product-raw/sample_data/modified_dt=2020-12-04,1621360560000) with 436 files
```



## Links

* https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-partitions.html
* https://aws.amazon.com/blogs/big-data/load-data-incrementally-and-optimized-parquet-writer-with-aws-glue/
