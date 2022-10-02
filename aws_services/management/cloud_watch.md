# CloudWatch

## General
* When configuring monitoring rules (e.g. glue job failures) ensure to actually test for failures before software release! Remember if you're cloud watch rule filter doesn't match you won't get notified if there are actual failures!

## Security
* When sending failure notifications via cloudwatch do NOT include PII information within the header/body of the message. It is OK to include AWS specific IDs.

```yaml
### Do this in email error notification body
"The Glue Job prod-TransformPolicyRelations FAILED at 2020-04-09T08:44:24Z."

## Do NOT do this in email body
"The Glue Job prod-TransformPolicyRelations FAILED at 2020-04-09T08:44:24Z. Client: John Jones, SSN: 111-22-3333"
```

## Naming standards (Cloud Watch Event Rules/Alarms)
* Utilize a common naming standard and include current execution environment

| Example | Description |
| -- | -- |
| productproductNightlyGlueJobMonitor-prd| Prd account rule for monitoring glue jobs for product application |
| productproductNightlyIngestionAlarm-dev-TrackingInfo | dev account rule for monitoring alarms for product tracking info component|

## Tagging
* Currently Cloud formation does NOT support automatic tagging of cloud watch rules. This must be done via the AWS CLI!
