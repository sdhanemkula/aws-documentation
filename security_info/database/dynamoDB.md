# DynamoDB

This page documents security considerations when using DynamoDB.

# General Guidance/Information
AWS DynamoDB outlines its security policies [here](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/security.html)

Notes:
* DynamoDB does NOT support VPC endpoint interface types (e.g. Private Link) but requires Gateway interface points (thus no VPC endpoint policies supported)

# Policy
* All dynamodb table data must be encrypted at rest
* Any usage of Dax acceleration must be encrypted at rest
* No global Table Usage

**Open Items**
* Restrict to VPC access only
* Role based access configured (dev role vs. service role)
* Table level permissions (e.g. group A can view tables Y whereas group B not access)
* Point in time recovery enabled

**Open Questions**
* Which encryption type do we require? AWS owned CMK, AWS Managed CMK, Customer managed CMK?
* Are we using DAX accelerator? If so then how encrypted?
* Who is responsible for securing the specific tables? IAM role/policy? Who creates/manages this?
* How fine grained do we need our access to be? Restrict items based on pkey values? If so these need to be applied to IAM users/groups/etc. so how does a developer do this?
* What is our monitoring options? (AWS config, CloudTrail, Streams)
* What is our tagging strategy for tables?
* What is our data retention (TTL) strategy for any sensitive data?

## Vpc endpoint policy
VPC endpoint policies are NOT supported by dynamoDB.
