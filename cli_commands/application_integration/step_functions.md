# Step Functions

These are some step functions related cli commands

```bash
## get last 3 failures for (rx models statemachine)
aws stepfunctions list-executions --state-machine-arn arn:aws:states:us-east-1:xxxxxxxxx:stateMachine:ace-appanalytics-ingestor-nightly-rx-models-prod --status-filter FAILED --max-items 3

## list out last 10 events from a given run
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:xxxxxxxx:execution:ace-appanalytics-ingestor-nightly-ra-prod:8612ce1b-8a57-6ed3-bca1-65856d834077_c1cf264c-f676-71aa-b8cb-0776612440f6 --reverse-order --max-items 10 | jq '.events[] '

## list out execution history error from run
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:xxxxxxxxx:execution:ace-appanalytics-ingestor-nightly-ra-prod:8612ce1b-8a57-6ed3-bca1-65856d834077_c1cf264c-f676-71aa-b8cb-0776612440f6 --reverse-order --max-items 10 | jq '.events[] | {id: .id, type: .type, name: .stateEnteredEventDetails.name, input: .stateEnteredEventDetails.input}'

## list out custom output values for a given execution run (and state transition e.g. 1)
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:xxxxxxxxx:execution:ace-appanalytics-ingestor-nightly-rx-models-prod:backfill_5_1_to_5_7_try2 --reverse-order --max-items 2 | jq '.events[1].stateEnteredEventDetails.input | fromjson'

## list out custom output JSON values for a given execution run (e.g. iterator, failedRiskIds)
aws stepfunctions get-execution-history --execution-arn arn:aws:states:us-east-1:xxxxxxxxxxx:execution:ace-appanalytics-ingestor-nightly-rmm-json-dev:Backfill_2019_05 --reverse-order --max-items 2 | jq '.events[1].stateEnteredEventDetails.input | fromjson | .failedRiskIds'

```