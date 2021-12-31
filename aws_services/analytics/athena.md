# Athena

## General
* Consider using workgroups to help separate out different users/use cases [more info here](https://docs.aws.amazon.com/athena/latest/ug/manage-queries-control-costs-with-workgroups.html)

## Storage
* Follow [JSON best practices for storing JSON data](https://docs.aws.amazon.com/athena/latest/ug/parsing-JSON.html) to be read directly
* Remember that partitioned data within a table requires partitions be loaded before usage within queries (e.g. msck repair table)
* Optimize file sizes in tables with large data sets (> 10GB). Presto reads HDFS based files so it's generally better to have larger files (128MB) vs. hundreds of thousands of small files (less S3 reads/metadata/spark tasks/etc.)

## Table/Column Standards
* Utilize separate databases for data delivered to the business from business user added data!
* Utilize a consistent naming standards for database names (env_product_database) ex. (dev_product_raw, prod_product_raw)
* Utilize camel_case table naming standards rx_script_check_details
* Utilize camel_case column naming standards with data type suffixes for dates (ended_dt) and timestamps (ended_ts)
* Utilize specific data types for all column data - avoid using string types for everything (e.g. integer, date, timestamp)
* Store all timestamps in UTC!
* Utilize the Array data type instead of hacking together string values (e.g. avoid having a single string column with 'value1,value2,value3' instead use ['value1', 'value2', 'value3'])

## Queries
* The Query UI is buggy so save any large queries to a local file! You've been warned!
* Utilize the presto functions to make queries simpler (https://prestodb.github.io/docs/0.172/functions.html)
* Remember you can't directly query XML!
* When creating complex queries utilize the 'WITH' syntax to make queries cleaner

```
WITH example
WITH all_responses AS (
SELECT riskid, rxModelResponse.drughic3code AS response_code
FROM risk_assessment_rx_models
CROSS JOIN UNNEST(response.rxModelResponses) AS t(rxModelResponse)
)
SELECT riskid, response_code FROM all_responses
WHERE riskid = '6967e2bb-ec40-4e3d-a21c-227e92039d90'
```

* When exporting data from Athena query into a CSV remember MS Excel may default the column type on you! For example "2019-09-10 15:18:21.644" may get shown as 18:21.6 in Excel
CTAS (Create table as Select) is very sensitive! S3 location must be empty, folder must exist, table can't pre-exist

## Costs
* You pay for what you scan not the results of the scan! So if repeatedly querying large datasets consider utilizing partitioning to break down data being scanned! (e.g. by dates, state code, etc.)

## Performance
* When performing joins with large table sizes (> 1GB) specify the larger table on the left side of join and the smaller table on the right side of the join
