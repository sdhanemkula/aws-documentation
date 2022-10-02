# SAM Lambda Policy Info
This section provides some notes I found trying to use SAM policy templates.

## General Guidelines
The yaml is super touchy!! Indentation and properties must be exact if not SAM will generate invalidate template. I saw values with null etc..

```yaml
Resources:
  EcsReaderFunction:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: !Join ["-", [!Ref EnvPrefix, "sam-python-ecs-reader"]]
      Policies:
        - S3ReadPolicy:                       <-- let me read S3
            BucketName: !Ref S3BucketName     <-- can use Cfn parameter references
        - S3WritePolicy:                      <-- let me write S3
            BucketName: !Ref S3BucketName
        - Statement:                          <-- custom hand crafted policy
          - Sid: ECSDescribeTasksPolicy
            Effect: Allow
            Action:
            - ecs:ListTasks
            - ecs:DescribeTasks
            Resource: '*'            

  BaseImageFinderFunction:
      Type: AWS::Serverless::Function
      Properties:
        FunctionName: !Join ["-", [!Ref EnvPrefix, "sam-python-base-image-finder"]]
        Policies:
          - LambdaInvokePolicy:                     <-- let me invoke other lambda
              FunctionName: !Ref EcsReaderFunction  <--- super touchy here wants reference to lambda NOT actual property
```


## References/Links
* [SAM Policy list](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-template-list.html)