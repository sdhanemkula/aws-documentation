# Simple Queue Service (SQS)
This page documents security considerations when using SQS.

# General Guidance/Information
Amazon SQS VPC endpoints provide two ways to control access to your messages:
* You can control the requests, users, or groups that are allowed through a specificVPCendpoint. 
* You can control which VPCs or VPCendpoints have access to your queue using a queuepolicy.

# Policy
* All queues must utilize vpc endpoints (created by ETS)
* All queues must utilize a vpc endpoint policy (created by ETS)
* All queues must define policy to restrict access at the vpc endpoint
* All queues should define policy to restrict access by principal and action
* All queues must ensure Server Side encryption

**Open Items include**
* SQS Cross Account Access (restrictions)
* Single Dev 'admin' role
* Enforce a dead letter queue
* Enforce least-privledge access (queue specific access policies)
* Enforce encryption of data in transit


## Vpc endpoint policy (ETS)
VPC endpoint policy will be created by ETS team for a given account. 

This policy grants:
* basic network access security
* basic service level action permissions
* account level principal/resource access (e.g. all queues in this account are connected to this vpc endpoint and ensure all principals have access to all resources)

```json
  VpcEndpointSQS:
    Properties:
      PolicyDocument:
        Statement:
        - Action:
          - sqs:DeleteMessage
          - sqs:GetQueueUrl
          - sqs:ChangeMessageVisibility
          - sqs:SendMessageBatch
          - sqs:ReceiveMessage
          - sqs:SendMessage
          - sqs:GetQueueAttributes
          - sqs:ListQueueTags
          - sqs:ListDeadLetterSourceQueues
          - sqs:DeleteMessageBatch
          Effect: Allow
          Principal: '*'
          Resource:
          - '*'
      PrivateDnsEnabled: true
      SecurityGroupIds:
      - Ref: SecurityGroupSqsEndpoint
      ServiceName: com.amazonaws.us-east-1.sqs
      SubnetIds:
      - Ref: TransitGWAzA
      - Ref: TransitGWAzB
      - Ref: TransitGWAzC
      VpcEndpointType: Interface
      VpcId:
        Ref: VPC
    Type: AWS::EC2::VPCEndpoint
```

## QueuePolicy
SQS:QueuePolicy should be utilized by developers to restrict access to queues at a resource level (e.g per Queue) 

This policy should restrict:
* access to only the vpce endpoint
* basic service level action permissions

**Sample denies all traffic NOT from our vpc endpoint**
```yaml
Type: AWS::SQS::QueuePolicy
Properties: 
  PolicyDocument: Json
  Queues: 
    - String
      {
         "Sid": "2",
         "Effect": "Deny",
         "Principal": "*",
         "Action": [
            "sqs:SendMessage",
            "sqs:ReceiveMessage"
         ],
         "Resource": "arn:aws::sqs:us-east-2:XXXXXXXXXXXX:queue1",
         "Condition": {
            "StringNotEquals": {
               "aws:sourceVpce": "vpce-1a2b3c4d"
            }
         }
      }

```

***Sample only permits Specific queue to restrict access to only DeleteMessage, RecieveMessage, SendMessage**
```yaml
{
  "Version": "2012-10-17",
  "Id": "cxtJPJobQueueAccessPolicy",
  "Statement": [
    {
      "Sid": "SqsReadWrite",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::XXXXXXXXXX:root"
      },
      "Action": [
        "sqs:DeleteMessage",
        "sqs:ReceiveMessage",
        "sqs:SendMessage"
      ],
      "Resource": "arn:aws:sqs:us-east-1:XXXXXXXX:cxtJPJobQueue",
      "Condition": {
        "StringEquals": {
          "aws:SourceVpce": "vpce-XXXXXXXXX"
        }
      }
    }
  ]
}
```
