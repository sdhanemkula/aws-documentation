# Cloud watch 

These are cloud watch samples

```bash

## find starting log message for given job in error logs stream
aws logs filter-log-events --log-group-name "/aws-glue/jobs/error" --log-stream-names jr_xxxxxx --max-items 10 --filter-pattern "STARTING Transform"

## find starting log message for a given job in output stream
aws logs filter-log-events --log-group-name "/aws-glue/jobs/output" --log-stream-names jr_xxxxxx --max-items 10 --filter-pattern "STARTING Transform" | jq '.events[].message'

## find all exception string for a given job (exception)
aws logs filter-log-events --log-group-name "/aws-glue/jobs/output" --log-stream-names jr_xxxxxxx --max-items 10 --filter-pattern "exception" | jq '.events[].message'

```

```bash
## describe all log grups for given name prefix
aws logs describe-log-groups --log-group-name-prefix mule_
aws logs describe-log-groups --log-group-name-prefix mule_ | jq '.logGroups[].logGroupName'


## describe all streams in a logs group
aws logs describe-log-streams --log-group-name mule_ace_product_api_production --log-stream-name-prefix prod


```