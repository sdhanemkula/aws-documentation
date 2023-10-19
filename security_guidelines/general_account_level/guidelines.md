# General Account
This page summarizes various guidelines related configuring items at the account level.

## Guidelines
Relevant guidelines to follow include:
* **Cloud Trail** - ensure cloud trail enabled for all regions, bucket is encrypted at rest, not publicly accessible
* **Cloud Watch Logs** - ensure all cloud watch logs are encyrpted using either CMK or KMS (depending on amount of CMK present)
* **AWS Config** - ensure AWS config enabled for all regions, try and record all possible resources to see changes
* **STS Token Service** - ensure service has reasonable timeout duration (typically 4 hours), deactivate service from un-used regions for better protection
* **Systems Mananger (SSM)** - ensure enabled and has logging configured with any sensitive data being encrypted using proper keys (CMK)


