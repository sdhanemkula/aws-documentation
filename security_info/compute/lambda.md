# Lambda Functions

This page documents security considerations when using Lambda.

# General Guidance/Information
Amazon Lambda by default runs as public service!

# Policy
* Ensure environment variables encrypted (default AWS behavior)
* Function NOT exposed publicly
* Lambda Function with Admin priviledges
* Lambda Cross Account Access
* No secrets are coded in env vars (no tokens, passwords, etc.)
* Restrict to VPC access only (ensure traffic limited)

**Open Items include**
* Utilize single IAM role per Lambda
* Lambda concurrent function level limits


## Lambda Role security
According to AWS documentation if we specify a role no lambda cloudformation policies will be applied thus any developer policies attempting to override security will not be assumed.

## Lambda Definition
Lambda definitions (SAM based or non-sam based) should always specify the following:
* Role  - IAM role to utilize in execution
* VpcConfig - VPC connection information

**sample lambda with role and vpc information**
```yaml
  CFNLambdaFindErrorsRiskAssessmentsHandler:
    Type: AWS::Lambda::Function
    Properties:
      Code:
        S3Bucket: !Ref CFNBucketNameSource
        S3Key: !Ref CFNBucketSourceKey
      Description: Find Errors
      FunctionName: !Join ["-", ["product-ingestor", !Ref CFNEnvPrefix, "FindErrors"]]
      Handler: com.ingestor.handlers.FindErrorsRiskAssessmentsHandler::handleRequest
      MemorySize: 256
      Role: !Ref CFNLambdaIAMRole           <--- ensure role defined
      Runtime: java11
      VpcConfig:                            <-- ensure vpc config defined with security groups
        SecurityGroupIds:
          - !Ref CFNSecurityGroupId
        SubnetIds: !Ref CFNSubnetIds
```
