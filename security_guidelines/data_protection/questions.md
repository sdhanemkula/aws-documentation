# Data Protection
This page summarizes various questions to ask related to the Data Protection pillar.

## Questions

* **What data do I have on disk ‘somewhere’?**
    * Seed data files, caches, logs, etc.

<br/>

* **What data/state does AWS maintain for me?**
    * Step functions state, SQS queue data, etc.
    * Note: various AWS services automatically maintain state (e.g. run history, logs, etc.) and depending on how you use the managed service this data may contain senstive data (e.g. PII). For example, if using step functions and want to pass state between lambdas using step functions state you could possible include PII data (e.g. SSNs, etc.).

<br/>

* **What is the lifecycle of that data?**
    * Temp, Long term, etc.
    * AWS services have defaults for the various data it may store. For example, cloud watch logs default to 'forever' whereas glue job execution history is kept for a certain amount of time.

<br/>

* **What is the data classification?**
    * Public, internal, confidential, restricted
    * If unsure how to categorize your data work with info security.

<br/>

* **How am I encrypting data at rest? In Transit?**
    * Encryption at rest typically uses KMS whereas in transit uses AWS public certs (depending on the managed service utilized)

<br/>

* **How am I avoiding data loss? Does service delete data after certain period automatically?**
    * AWS services (e.g. lambda, sqs, step functions, etc.) support various retry mechanisms and failure to understand and use these can cause inadvertant data loss (e.g. SQS readMessage lambda throws exception then fails can remove item from queue with no processing on it)

<br/>

* **Am I accidentally exposing PII via managed services?**
    * Depending on what I decide to log, use as keys I could potentially expose PII. For example, we should avoid using SSN for any type of state key in services like step functions, etc.