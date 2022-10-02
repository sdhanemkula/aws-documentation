# Step Functions

## General Guidelines
* Understand all limits on Step Functions when designing workflows (SOME CAN and CAN'T BE CHANGED)
  - [more info here](https://docs.aws.amazon.com/step-functions/latest/dg/limits.html)
* Passing state between step functions is limited to 32K within any given state change
* Using Map state only supports 40 concurrent tasks at a time!
* Using Map state costs approx 7 state entries per map iteration (MapIterationStarted,TaskStateEntered,LambdaFunctionScheduled,LambdaFunctionStarted,LambdaFunctionSucceeded,TaskStateExited,MapIterationSucceeded). 
* Step functions has a hard limit to 25K states in history! If using map state inside state machine must factor the 7 state entries into total size of records to be processed (3400 map iterations is a safe limit to consider depending on size of other states in state machine)



## Supportability
* Utilize Retry handlers to handle AWS level errors vs. application specific errors (You will experience AWS errors!)
  - [more info here](https://docs.aws.amazon.com/step-functions/latest/dg/tutorial-handling-error-conditions.html)
* Utilize Timeouts to avoid stuck executions
  - [more info here](https://docs.aws.amazon.com/step-functions/latest/dg/sfn-stuck-execution.html)
* Integrate state machine event history with cloud watch events! This enables easy debugging of state machine history via basic log insights log queries (e.g. search through 2000 events easily).
```yaml
# Define simple log group
CFNStateMachineLogGroupRaJson:
  Type: AWS::Logs::LogGroup
  Properties:
    LogGroupName: !Join ["-", ["/aws/stepfunction/product-ingest", !Ref CFNEnvPrefix, "ra-json"]]
    RetentionInDays: 14
```
```yaml
# define state machine with reference to Log Group (logs events to cloud watch!)
CFNStepFunctionsNightlyRaJson:
  Type: AWS::StepFunctions::StateMachine
  Properties:
    StateMachineType: STANDARD
    LoggingConfiguration:
      Destinations:
        - CloudWatchLogsLogGroup:
            LogGroupArn: !GetAtt CFNStateMachineLogGroupRaJson.Arn
      IncludeExecutionData: True
      Level: ALL
```



## Performance
* Utilize the Map state to easily loop through an array of values to run concurrent lambdas for each item in the array
