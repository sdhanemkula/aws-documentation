# API Gateway Private Configuration Information
This page summarizes information on setting up a private API Gateway Service with Lambda integration.

## General
* Configuring requires a VPC endpoint Id (e.g. vpce-XXXXXXXXXXXXXXX) as well as the VPC Id (e.g. vpc-XXXXXXXXXXX)
* Invoking the API from within the VPC requires usage of the existing default endpoint (e.g. https://5014dl3tn3.execute-api.us-east-1.amazonaws.com)
* Invoking the API from outside the VPC (but on PM network over direct connect) requires additional setup (see below)


## Setup Notes
Setting up the gateway includes these steps:
* Create gateway using VPC endpoint Id
* Modify Gateway policy to include proper deny/allow permissions from only the VPC

```
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Deny",
           "Principal": "*",
           "Action": "execute-api:Invoke",
           "Resource": "arn:aws:execute-api:us-east-1:XXXXXXXXX:5014dl3tn3/*/*/*",  <=== Everything
           "Condition": {
               "StringNotEquals": {
                   "aws:sourceVpc": "vpc-XXXXXXXXXXX"  <=== VPC ID want to grant permissions to!
               }
           }
       },
       {
           "Effect": "Allow",
           "Principal": "*",
           "Action": "execute-api:Invoke",
           "Resource": "arn:aws:execute-api:us-east-1:XXXXXXXXXXX:5014dl3tn3/test/POST/*"  <== specific
       }
   ]
}
```

* **Deploy the gateway when making policy changes before testing outside access**


## Testing locally (not in VPC)
When using a API testing tool like Postman (or if running integrations on local laptop) there are two things to configure:
* URL for invocation
* HTTP Header information to include

[Detailed information is here in the AWS documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-api-test-invoke-url.html)

* Create the url using the VPC endpoint's public DNS (**only because we're running over direct connect**)

|VPC Public DNS  | API gateway stage | Resource |
| -- | -- | -- |
| vpce-XXXXXXXXXXX-05583b1h  | test  | illustrations/calc/annuity |

```
# Example Url for local invocations
https://vpce-XXXXXXXXXXX-05583b1h.execute-api.us-east-1.vpce.amazonaws.com/test/illustrations/calc/annuity?scope=internal

```


* Add in the API gateway's default endpoint to the HTTP HEADER 'HOST' in the call

|HTTP Header   | Example |
| -- | -- |
|HOST   | 5014dl3tn3.execute-api.us-east-1.amazonaws.com  |


## Creating private gateway from an existing public API gateway
When importing a public gateway to a private gateway there were some issues discovered.

* The resources imported correctly with all relevant integrations but the Lambda policies were NOT created permitting the new gateway execute the lambdas. This seems like a bug in AWS. To fix you need to navigate to each resource method's Integration request and delete/re-add the lambda connection (thus forcing the policy to be added to the lambda). Checking the lambda => Permissions should show all gateway permissions like below

```
# Sample permissions for lambda to be invoked from API gateway resource/method
{
    "Sid": "d60d0425-b3a7-4c15-87e6-4499fdc7157d",
    "Effect": "Allow",
    "Principal": {
      "Service": "apigateway.amazonaws.com"
    },
    "Action": "lambda:InvokeFunction",
    "Resource": "arn:aws:lambda:us-east-1:XXXXXXXXXXX:function:IllustrationCalcAnnuity",
    "Condition": {
      "ArnLike": {
        "AWS:SourceArn": "arn:aws:execute-api:us-east-1:XXXXXXXXXXX:5014dl3tn3/*/POST/illustrations/calc/annuity"
      }
    }
  }
```
