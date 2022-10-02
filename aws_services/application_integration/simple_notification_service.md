# Simple Notification Service (SNS)

## General Guidelines (Topics)
* Ensure to set the proper topic policy if using topic as destination (e.g. cloud watch events)

```yaml
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

## Naming
* Use application/environment in all names. (e.g. product-product-support-notifications-dev)
