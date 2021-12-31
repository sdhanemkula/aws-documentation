# Glue Bookmarks

This file contains all the relevant Glue Bookmark information. This information was obtained via a POC of using glue bookmarks against S3 JSON data only!

## General Glue Bookmark Information
* Bookmarks are enabled at the job level only! Can't define bookmark across multiple different jobs as a set.
* S3 file bookmarks do search across previously processed partitions and use the S3 files' modified TS as the value to determine if file is 'changed'. So even if glue has already processed a partition from a previous job it will still find this new file. One huge drawback of this design is performance impact if there are thousands of partitions. It results in glue searching each of them to compare time stamps which could be costly on performance.

* Besides enabling bookmarks at the job level you must also define a transformationContext on the source!
```
 // must include transformationContext when retrieving source
val datasource0 = glueContext.getCatalogSource(database = src_db, tableName = src_table, redshiftTmpDir = "",transformationContext = "datasource0").getDynamicFrame()
```

* For jobs having multiple input sources can mix/match sources bookmarked by excluding the transformationContext 
```
 // must include transformationContext when retrieving source for bookmark
val datasourceWithBookmark = glueContext.getCatalogSource(database = src_db, tableName = src_table, redshiftTmpDir = "",  transformationContext = "datasource0").getDynamicFrame()

// but DO NOT include transformationContext for other source not wanting bookmark
val datasourceWithOutBookmark = glueContext.getCatalogSource(database = src_db, tableName = src_table, 
redshiftTmpDir = "").getDynamicFrame()      
```

* glue bookmarks can be either 'reset' or 'rewound'.
* Resetting a bookmark basically deletes the existing information. Once this is done you've basically lost all previous book information and must re-process all your data
* 'Rewinding' a bookmark permits you to 'move the bookmark backward' to a previous job run. This is helpful when loading historical data but YOU are responsible for updating the existing data which can be tricky.

## Glue Bookmark Debugging
Glue offers a couple of different options for debugging what the bookmark process 'modified' set returned was.

* Search Cloudwatch logs for text "Skipping Partition"
```	
glue.HadoopDataSource (Logging.scala:logWarning(22)): Skipping Partition {"modified_dt": "2017-10-08"} as no new files detected @ s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2017-10-08 or path does not exist
```

* Search Cloudwatch logs for "Found new partition"
``` 	
hadoop.PartitionFilesListerUsingBookmark (FileSystemBookmark.scala:apply(351)): Found new partition DynamicFramePartition(com.amazonaws.services.glue.DynamicRecord@6d84f97d,s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2021-05-15,1621517961000) with 87 files
```

* Search Cloudwatch logs for "After initial job bookmarks filter"
``` 	
2021-05-19 19:52:18,474 INFO [main] hadoop.PartitionFilesListerUsingBookmark (FileSystemBookmark.scala:apply(356)): After initial job bookmarks filter, processing 0.00% of 474 files in partition DynamicFramePartition(com.amazonaws.services.glue.DynamicRecord@1a1897f,s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2020-12-04,1621360560000).
```

* Search Cloudwatch logs for "After final job bookmarks filter"
```
2021-05-19 19:54:36,260 INFO [main] hadoop.PartitionFilesListerUsingBookmark (FileSystemBookmark.scala:apply(155)): After final job bookmarks filter, processing 0.00% of 0 files in partition DynamicFramePartition(com.amazonaws.services.glue.DynamicRecord@1a1897f,s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2020-12-04,1621360560000).
```

* Search glue job's temp directory for JSON file listing all partitions searched and what it processed
```
# temp file location (location + job_run_id)
	s3://aws-glue-temporary-885391300939-us-east-1/partitionlisting/dev-TransformQuestionsIncremental/jr_34a57533f332e1c68fc536bba32e5400119538c377f6e7be59decb9e9e153515/

 # inside JSON look for (item.path and item.files)
	item.path => s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2020-05-01
	item.files => [ "s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2021-05-14/006e1ad8-4cf6-421e-90ab-d7af3129543e_4.json",
      "s3://us-east-1-prd-product-raw/risk_assessments/modified_dt=2021-05-14/0097ba31-b178-40c4-99fc-4be393e87d01_4.json" ]
```



## Links

* https://aws.amazon.com/blogs/big-data/load-data-incrementally-and-optimized-parquet-writer-with-aws-glue/
* https://docs.aws.amazon.com/glue/latest/dg/monitor-continuations.html
