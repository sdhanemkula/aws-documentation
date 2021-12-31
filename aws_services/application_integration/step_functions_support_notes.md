# Step Functions Support Notes

The step functions support notes are examples of how to 'find' the needle in the haystack of a given step function run. Since each run may have approx 1200 events it can be hard to isolate what actually failed when.

There are two ways to look for errors:
* Log Insights - use Log insights to query for relevant state machine events (much much easier!)
* AWS CLI/JQ - use AWS cli commands to find relevant things


## Log Insights
Since step function events are now integrated with cloud watch events we can use Log Insights to run queries against the events to 'find the needle in the haystack'.

```
-- list out last 20 events from a given run
fields @timestamp, @message
| filter execution_arn = 'arn:aws:states:us-east-1:885391300939:execution:product-product-ingestor-nightly-dev-ra-json:2a7c3caf-586e-24c3-2fd3-2c26a9908aeb'
| sort @timestamp desc
| limit 20

-- list out failed state of last 20 runs
fields @timestamp, @message
| filter type = 'ExecutionFailed'
| sort @timestamp desc
| limit 20

-- pull out the failed id string to see which index failed
parse @message "* failedTrackingIds*" as @prefix, @failedIdString
| display @failedIdString, @message, @prefix
| filter type = 'ExecutionFailed'
| sort @timestamp desc
| limit 20

--
```

## AWS CLI/JQ
These example scripts assume you have jq installed locally! [jq is here](https://stedolan.github.io/jq/)

```
-- get last 3 failures for (rx models statemachine)
aws stepfunctions list-executions --state-machine-arn arn:aws:states:us-east-1:XXXXXXXXXXX:stateMachine:product-ingestor-nightly-rx-models-prod --status-filter FAILED --max-items 3

-- list out last 10 events from a given run
-- need to find the arn of the given statemachine first!
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:XXXXXXXXXXX:execution:product-ingestor-nightly-ra-json-prod:2aa5c943-fee9-e897-8d50-94225f3e9b17_506c39cc-479d-cc83-e7aa-6ea93f388ddc --reverse-order --max-items 10 | jq '.events[] '

-- list out execution history error from run
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:XXXXXXXXXXX:execution:product-ingestor-nightly-ra-json-prod:2aa5c943-fee9-e897-8d50-94225f3e9b17_506c39cc-479d-cc83-e7aa-6ea93f388ddc --reverse-order --max-items 10 | jq '.events[] | {id: .id, type: .type, name: .stateEnteredEventDetails.name, input: .stateEnteredEventDetails.input}'

-- list out custom output values for a given execution run (and state transition e.g. 1)
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:XXXXXXXXXXX:execution:product-ingestor-nightly-ra-json-prod:2aa5c943-fee9-e897-8d50-94225f3e9b17_506c39cc-479d-cc83-e7aa-6ea93f388ddc --reverse-order --max-items 2 | jq '.events[1].stateEnteredEventDetails.input | fromjson'

-- list out custom output JSON values for a given execution run (e.g. failedRiskIds)
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:XXXXXXXXXXX:execution:product-ingestor-nightly-ra-json-prod:2aa5c943-fee9-e897-8d50-94225f3e9b17_506c39cc-479d-cc83-e7aa-6ea93f388ddc --reverse-order --max-items 2 | jq '.events[1].stateEnteredEventDetails.input | fromjson | .failedRiskIds'

```
