# API Gateway
This page summarizes information on API Gateway Service.

## General
* Refer to the associated PDF **(AWSAPIGatewayNotes.pdf)** for a listing of various features, design considerations when deciding if need to use API gateway
* Public API gateways should NOT be used unless approved and created with help from ETS linux team! Creating a private API gateway involves extra configuration which can be found in a separate Markdown file in this directory.
* Refer to the other markdown documents from more information on Validations, Lambda integration, transformations, etc.
* The API gateway 'test' feature assumes all HTTP Content-Type "application/json" regardless of what is configured in the HTTP headers section (e.g. 'application/xml' did not work)

## Limits to Consider
* **Maximum integration timeout	is limited to 30 seconds!** This can be problematic since lambdas can run for up to 15 minutes. In this scenario the gateway will return a timeout but the lambda will still continue!
* Payload size is limited to 10MB and can't be adjusted!
* Request line and headers is limited to 10240 Bytes and can't be adjusted!
* Refer to [AWS API Gateway Limits](https://docs.aws.amazon.com/apigateway/latest/developerguide/limits.html)

## Costs
* TODO
