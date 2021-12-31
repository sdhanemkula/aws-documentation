# Elastic container repository

This page documents security considerations when using ECR.

# General Guidance/Information
Amazon Container Repository provides [security within the service](https://docs.aws.amazon.com/AmazonECR/latest/userguide/security.html)

Notes:
* AWS encrypts all data rest by default

# Policy
* No ECR Repository exposed
* Repository w/cross account access utilizes explicit permissions
* No public ECR repository

**Open Items include**
* Ensure ECR tags are immutable
* Enable scan on push for ECR images




