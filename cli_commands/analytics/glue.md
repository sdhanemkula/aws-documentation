# Glue

Some basic glue cli commands

```bash
# get glue jobs with maxResults 2
aws glue get-jobs --cli-input-json "{'MaxResults':2}"

# get glue job runs for job named 
aws glue get-job-runs --job-name "fdl/company"

# get partitions for database/table with partition values
aws get-partition --database-name "fdl" --table-name "lead_event" --partition-values "source_dt" "insert_job_run_id"

# get partitions for database/table and dump to local file
aws glue get-partitions --database-name "fdl" --table-name "lead_event" > ~/Documents/lead_event_partitions.json

# see all triggers
aws glue get-triggers

## list out only jobs for a given ENV (prod/DEV)
aws glue get-jobs --max-items 40 | jq '.Jobs[].Name | select(startswith("prod"))'

## list out last 4 job runs for a given job name (all results)
aws glue get-job-runs --job-name AAA-MIBTXNData --max-items 4

## list out last 4 job runs for a given job name (e.g. AAA-MIBTXNData) id and statues
aws glue get-job-runs --job-name AAA-MIBTXNData --max-items 4 | jq '.JobRuns[] | { id: .Id, name: .JobName, state: .JobRunState, end: .CompletedOn | todate}'

## list out all jobs in account (for given prefix)
aws glue get-jobs --max-items 40 | jq '.Jobs[] | { name: .Name}'

## list out last failures for given job name
aws glue get-job-runs --job-name AAA-MIBTXNData --max-items 10 | jq '.JobRuns[] | select(.JobRunState != "SUCCEEDED")'

## list out last failures for given job name (abbreviated data)
aws glue get-job-runs --job-name AAA-MIBHistoricalData --max-items 10 | jq '.JobRuns[] | select(.JobRunState != "SUCCEEDED") | { id: .Id, time: .CompletedOn | todate, state: .JobRunState, message: .ErrorMessage}'


```