# Elastic container Service

This page documents security considerations when using ECS.

# General Guidance/Information
Amazon Container Service provides [security within the service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/security.html)

# Policy
* Containers NOT running as root
* Containers using only read only root file system
* Containers not running as priviledged
* Containers access exposed (remove any unneeded linux tools from image)
* Container storate exposed (encrypt fargate ephemeral storage)
* Container credentials exposed w/in code (secrets manager only)
* Container credentials exposed w/in IaaC (system parameter store)
* Container networking exposed (use networking encryption where possible)
* Container network traffic isolation (run in separate VPCs)
* Container admin acess to AWS services (use VPC endpoints for all service integrations)
* Container services exposed (IAM roles scoped to least access)

**TODO: how is IAM managed here?**

**Open Items include**
* TODO


## Vpc endpoint policy (ETS)

**TODO what is our policy?**

## Other Info

**TODO what other relevant info is required here?**





