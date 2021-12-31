# Glue Job Support Notes

The glue job examples are for finding details on a given job name or job run. Typically this information is easily found in the UI so these may not be utilized much.

These example scripts assume you have jq installed locally! [jq is here](https://stedolan.github.io/jq/)

```
-- list out only jobs for a given ENV (prod/DEV)
aws glue get-jobs --max-items 40 | jq '.Jobs[].Name | select(startswith("prod"))'

-- list out last 4 job runs for a given job name (all results)
aws glue get-job-runs --job-name prod-TransformQuestions --max-items 4

-- list out last 4 job runs for a given job name (e.g. prod-TransformQuestions) id and statues
aws glue get-job-runs --job-name prod-TransformQuestions --max-items 4 | jq '.JobRuns[] | { id: .Id, name: .JobName, state: .JobRunState, end: .CompletedOn | todate}'

-- list out last failures for given job name
aws glue get-job-runs --job-name prod-TransformMVRDetails --max-items 30 | jq '.JobRuns[] | select(.JobRunState != "SUCCEEDED")'

-- list out last failures for given job name (abbreviated data)
aws glue get-job-runs --job-name prod-TransformMVRDetails --max-items 30 | jq '.JobRuns[] | select(.JobRunState != "SUCCEEDED") | { id: .Id, time: .CompletedOn | todate, state: .JobRunState, message: .ErrorMessage}'

```

Cloud watch log queries for a given job failure!

```
-- find starting log message for given job in error logs stream
aws logs filter-log-events --log-group-name "/aws-glue/jobs/error" --log-stream-names jr_4e82649e13d86d540ab52862e972137ba60148f8240d06d308697e6b8423c87c --max-items 10 --filter-pattern "STARTING Transform"

-- find starting log message for a given job in output stream
aws logs filter-log-events --log-group-name "/aws-glue/jobs/output" --log-stream-names jr_4e82649e13d86d540ab52862e972137ba60148f8240d06d308697e6b8423c87c --max-items 10 --filter-pattern "STARTING Transform" | jq '.events[].message'

-- find all exception string for a given job (exception)
aws logs filter-log-events --log-group-name "/aws-glue/jobs/output" --log-stream-names jr_4e82649e13d86d540ab52862e972137ba60148f8240d06d308697e6b8423c87c --max-items 10 --filter-pattern "exception" | jq '.events[].message'
```
