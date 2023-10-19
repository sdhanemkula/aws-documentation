# Detective Controls
This page summarizes various guidelines related to the Detective Controls pillar.

## Guidelines
Relevant guidelines to follow include:

* **All services must integrate with cloud watch for application logging**
    * No proprietary/homegrown logging solutions permitted
    * Ensuring all services log to cloud watch permits us to easily perform cross queries using log insights, or run security scans on the logs to detect security incidents. etc.

<br/>

* **All native AWS services must integrate with Cloud Trail**
    * Required audit retention policies should be created

<br/>

* **Developer created CloudWatch log groups must be configured to follow standard retention policies (based on some audit policy)**
    * **PRD**: 5 years
    * **QA**: 6 months
    * Most AWS services handle log group creation automatically but some services like step functions permit the ability to store it's state history into cloud watch for easy querying, auditing, etc.

<br/>

* **Any publicly facing integrations must utilize alarms for detecting potential security threat behavior**
    * E.g. Public SQS queue receive > 1000 items in an hour
    * Utilizing cloud watch alarms when large volumne spikes is an easy way to see DDS type of attacks

<br/>

* **Private facing integrations may utilize alarms for detecting potential security threat behavior (nice to have)**
    * E.g. SQS queue receive > 1000 items in an hour (if should never happen)
    * Although not required, adding alarms for certain services (e.g. SQS, etc.) increases overall application observability

<br/>

* **Default logging level should NOT be DEBUG in PRD!**
    * DEBUG level debugging can potentially expose dangerous data at times
    * DEBUG logging maybe used in PRD to help resolve issues
    

<br/>

* **If possible enable Guard Duty in all regions**

<br/>

* **If possible enable Macie to scan/indicate all potentially sensitive data**

<br/>

* **If possible enable AWS Shield advanced and ensure any public resources are automatically added (e.g. elastic IPs, etc.)**

<br/>


* **Ensure VPC flog logs configured for all VPCs with storage to either cloud watch logs for a minimum duration of 30 days for DEV accounts. Production accounts should be configured to store logs to S3 and store for at least a year**

<br/>

* **Ensure S3 public buckets have access logging enabled**

<br/>

* **Enable Trusted advisor for all DEV accounts and add manual review/application of findings to any sprint cycles (e.g. once a sprint/month/etc.)**

<br/>


* **Create a centralized security account to store/analyze all security detection related information from all other AWS accounts w/in the organization**
    * Store VPC Flog logs, cloud trail logs and other important cloud watch information

<br/>

* **Ensure API Gateway has access logging enabled (esp for public API gateways)**

<br/>
