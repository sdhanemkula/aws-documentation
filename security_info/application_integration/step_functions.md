# Step Functions

This page documents security considerations when using Step Functions.

# General Guidance/Information
AWS Step Functions outlines its security policies [here](https://docs.aws.amazon.com/step-functions/latest/dg/security.html)

General notes:
* Step functions always encrypts any data at rest defined in the service
* Step functions always encrypts any data transferred between the service and other services (e.g.lambda)

# Policy
* All cloud watch log data from step functions is encrypted by default (developers required to integrate with cloud watch)
* State machine data is encrypted at rest/transit by AWS by default
* All service access permissions are managed by IAM roles defined by ETS (see below)

**Open items include**
* Restrict to VPC access only

## Vpc endpoint policy (ETS)
VPC endpoint policy are NOT created by ETS team for a given account.

**TODO: define if how we should do this**

## Sample step functions IAM policy
This sample step functions role demonstrates:
* required logging permissions
* required lambda permissions
* required sns topic permissions

```yaml
  PmlStepFunctionsExecutionPolicyproduct:
    Properties:
      Description: Allows product Step Functions to invoke Lambda Functions
      ManagedPolicyName: PmlStepFunctionsExecutionPolicyproduct
      Path:
        Fn::Sub: /${AWS::AccountId}/${AWS::Region}/${AppEnv}/product/
      PolicyDocument:
        Statement:
        - Action:
          - logs:DescribeResourcePolicies
          - logs:DescribeLogGroups
          Effect: Allow
          Resource: '*'
          Sid: AllowCloudwatchLogging
        - Action:
          - lambda:InvokeFunction
          Effect: Allow
          Resource: '*'
        - Action:
          - sns:Publish
          - sns:ListTopics
          Effect: Allow
          Resource: '*'
          Sid: AllowSnsPublish
        Version: '2012-10-17'
    Type: AWS::IAM::ManagedPolicy
```