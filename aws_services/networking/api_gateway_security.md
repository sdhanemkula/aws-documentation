# API Gateway Security
This page summarizes information on seucring API Gateway Service (authentication/authorization).

## General
Numerous ways to secure APIs include:
* **API-KEYs** - generate key w/in API gateway and look for key in request headers (X-API-KEY)
* **IAM-Roles** - API developer attaches policy to IAM role (used from consumer - user, group, assumed role, etc.)
* **Cognito-User Pool** - User pool serves as an identity provider, supports registration and provides identity tokens (JWT)

### API-KEYs
Notes:
* To use API-KEYs consumers must use the AWS Developer Portal
* Best used for internal intra application integrations
* Add to header in x-api-key
* Appears to require usage plans as well (unsure of this)
* TODO: provide more info here when possible

### IAM-ROLES
Notes:
* Must set API method authorizationType to AWS_IAM
* TODO: provide more info here when possible

https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html


### Cognito-User Pools
Notes:
* The API developer creates a User-Pool, and creates an API Gateway authoriser connected to the User-Pool and enables the authoriser on selected API methods.
* The API developers shares the User-Pool ID, a client ID, and possibly the associated client secret with the API consumer.
* The API consumer then registers with the User-Pool. The User-Pool provides the sign-in functionality, and provisions the identity (JWT) token to the signed in consumer.
* The API consumer then sends the JWT token with the HTTP request.
* The API Gateway verifies the JWT token to ensure it belongs to the configured User-Pool and authenticates the consumer before passing the request to the backend system.
* Effective for external API requests
* Can be used with custom lambda authorizer to verify JWT tokens

## Securing via VPC endpoint policy
To restrict the API gateway to only permit traffic from a given VPC

```yaml
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
       }
   ]
}
```

## Securing via Resource Policies
Secure API to only accept requests from a given principal for certain actions only

```yaml
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Principal": {
                "AWS": [
                    "arn:aws:iam::123412341234:user/MyUser"     <== only specific user can use this
                ]
           },
           "Action": "execute-api:Invoke",
           "Resource": "arn:aws:execute-api:us-east-1:XXXXXXXXXXX:5014dl3tn3/test/POST/*"  <== specific
       }
   ]
}
```

