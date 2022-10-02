# Lambda Log Insights Support Queries
Cloud Watch insights can be utilized to easily search all Cloud watch logs for a given error/issue/etc.

This section outlines queries to run to help when diagnosing issues.

```sql
## show counts of any log messages with 'ERROR' in them by 15 minute intervals sorted by highest count first
filter @message like /ERROR/
| stats count(*) as exceptionCount by bin(15m)
| sort exceptionCount desc

## select lambda, timestamp, message from any logs having 'ERROR' in the message (sorted by latest first)
parse @log "XXXXXXXXXXX:/aws/lambda/*" as lambda |
fields @timestamp, @message
| filter (@message like /ERROR/)
| sort @timestamp desc

## Find entire stack of message for a given lambda requestId
fields @timestamp, @message
| filter @requestId = "570bb57c-42a7-471b-9efb-c94c19231201"
| sort @timestamp desc

## List all memory information for all lambdas executions
parse @log "XXXXXXXXXXX:/aws/lambda/*" as lambda |
filter @type = "REPORT" |
fields @requestId, @maxMemoryUsed, @memorySize |
stats max(@maxMemoryUsed), max(@memorySize), max(@duration), min(@duration) by lambda |
sort by lambda asc

```
