# Secrets Manager

This page documents security considerations when using Secrets Manager.

# General Guidance/Information
AWS Secrets manager outlines its security policies [here](https://docs.aws.amazon.com/secretsmanager/latest/userguide/security.html)

# Policy
* All applications are required to store application 'secrets' in secrets manager
* Most SECRETS should be stored in the central AWS 'secrets' account. Each development account will be granted permissions to secrets within this account based on secret names.
* Developer should NOT have permissions to create secrets in cloudformation templates
* Secrets are stored encrypted using customer based KMS keys
* Secrets should not be publicly exposed
* Secrets are restricted for cross account usage
* Secrets access by default utilizes AWS VPC endpoints (see below)

**Open items include**
* **TODO: what items required here**


## Vpc endpoint policy
VPC endpoint policy are supported by Secrets Manager and currently used by development teams.

