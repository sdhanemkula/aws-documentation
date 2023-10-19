# Deployment
This page summarizes various guidelines related to the Deployment pillar.

## Guidelines
Relevant guidelines to follow include:

* **All infrastructure must be defined in Code (IaaC)**
    * Must use either Cloud Formation or SAM templates or Terraform
    * This code should be scanned with tooling for potential security issues (e.g. cloud formation guard, checkov, etc.)

<br/>

* **Ansible should only be used to ‘orchestrate’ IaaC deployment**
    * Do not use the native ansible AWS modules to define specific AWS services instead use Cloud Formation/SAM templates!
    * Even though ansible has some custom aws modules this code can't be scanned for compliance and additionally the ansible modules are typically not kept up to date and lag behind AWS CF.

<br/>

* **All IaaC should be scanned for vulnerabilities w/in CI via Automated tool (e.g. Checkov)**

<br/>

* **All AWS deployments should be done via build server (not manual)**
    * Jenkins used to provides audit checks, gating, etc.

<br/>

* **Developers can assume CI ‘user’ utilized during deployment is configured with same permissions as DEV role**
    * Jenkins security policies mimic current project's Dev settings vs. using a single all-encompasing security policy

<br/>


* **Manual deployments to DEV Account are permitted but must be validated via Jenkins**
    * Testing IaaC code, developer specific testing, etc.
    * Limited to resources developers are permitted to create (e.g. Lambdas, Step functions, but NOT S3 buckets, etc.)
    * Note: remember account level namespacing exists if using developer specific deployments (e.g. Queue names, DB names, etc.)

<br/>

* **ECR private repositories storiing docker images are not configured to have a policy to permit public access**

<br/>

* **Build servers connecting to AWS resources must use access keys (not user/password) and keys should be rotated every month**

<br/>

* **ECR image scanning should be enabled on push if possible**

<br/>
