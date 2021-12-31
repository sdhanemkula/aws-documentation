# Simple Notification Service (SNS)

This page documents security considerations when using SNS.

# General Guidance/Information
Amazon SNS VPC endpoints provide two ways to control access to your messages:
* You can control the requests, users, or groups that are allowed through a specificVPCendpoint. 
* You can control which VPCs or VPCendpoints have access to your queue using a queuepolicy.

# Policy
* All topis must utilize vpc endpoints
* All topics must utilize a vpc endpoint policy
* All topics must define policy to restrict access at the vpc endpoint
* All topics should define policy to restrict access by principal and action
* All topics must ensure Server Side Encryption
* SNS Topic Subscribe not public
* SNS Topic Publish not public

**Open items include**
* SNS Cross Account Access (restrict)
* Single Dev 'admin' role
* Enforce least-privledge access (topic specific)
* Enforce encryption of data in transit

## Vpc endpoint policy
VPC endpoint policy should be created by networking team for a given account. 

This policy grants:
* basic network access security
* basic service level action permissions
* account level principal/resource access (e.g. all queues in this account are connected to this vpc endpoint and ensure all principals have access to all resources)


## SNS::TopicPolicy
SNS:TopicPolicy should be utilized by developers to restrict access to queues at a resource level (e.g per Queue) 
For example to set the proper topic policy if using topic as destination (e.g. cloud watch events)

This policy should restrict:
* access to only the vpce endpoint
* basic service level action permissions

**Sample permitting cloudwatch notification access**
```
## Sample cloudformation demonstrating policy to permit cloud watch to publish to
## topic in CFNSnsTopicproductCloudWatchNotification variable
Effect: Allow
Principal:
  AWS: "*"
Action:
  - "SNS:GetTopicAttributes"
  - "SNS:SetTopicAttributes"
  - "SNS:AddPermission"
  - "SNS:RemovePermission"
  - "SNS:DeleteTopic"
  - "SNS:Subscribe"
  - "SNS:ListSubscriptionsByTopic"
  - "SNS:Publish"
  - "SNS:Receive"
Resource: !Ref CFNSnsTopicproductCloudWatchNotification
Condition:
  StringEquals:
    "AWS:SourceOwner": !Ref AWS::AccountId
- Sid: Allow_Publish_Events
Effect: Allow
Principal:
  Service: "events.amazonaws.com"
Action: sns:Publish
Resource: !Ref CFNSnsTopicproductCloudWatchNotification
```

**Sample Topic policy restricting publish message to only traffic from within my vpc**
```json
Type: AWS::SNS::TopicPolicy
{
  "Statement": [{
    "Effect": "Deny",
    "Principal": "*",
    "Action": "SNS:Publish",
    "Resource": "arn:aws:sns:us-east-2:444455556666:MyTopic",
    "Condition": {
      "StringNotEquals": {
        "aws:sourceVpce": "vpce-1ab2c34d"
      }
    }
  }]
}

```