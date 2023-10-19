# Data Protection
This page summarizes various guidelines related to the Data Protection pillar.

## Guidelines
Relevant guidelines to follow include:

* **Any data w/in AWS managed service must be encrypted at rest and in-transit**

<br/>

* **KMS should be used for all encryption with managed services**

<br/>

* **All Secrets manager secrets should be encrypted using CMK**

<br/>


* **ALB HTTPs termination w/in ECS cluster is OK if using awsVPC network mode**
    * E.g. ECS hosted spring boot component can be HTTP only
    * Since ALB/ECS runs within private network in AWS make spring application processing simpler/faster due to no SSL

<br/>

* **Developers should establish data lifecycle policies for managed services with PERSISTENT storage**
    * E.g. Define S3 lifecycle policy for S3 objects. S3 can automatically remove or transition data into different storage tiers. For systems using S3 buckets with senstive data it is probably prudent to either move or delete older data after a given period of time.
    * E.g. DynamoDB TTL for items in 'hot storage' to ensure being removed after a period of time.

<br/>

* **AWS system generated alarm/event notifications data must NOT include PII**
    * SNS notifications can be configured to send via email, text, etc. which can be unsecure!
    * E.g. SNS job or step function failure emails only include job name/times, etc.
    ```bash
    # example valid message (limited to job name and time of failure)
    The State Machine arn:aws:states:us-east-1:541623049223:execution:clarifi-appanalytics-ingestor-nightly-prd-rmm-json:e47d5f3c-5a74-64f8-1f46-b10f1b05b486_bf091c7d-2f6e-95b8-55ed-3c39ab56b1cb FAILED at 2021-08-07T05:15:41Z.

    # bad message (don't inlucde PII in message being sent)
    The state machine arn:aws:states:us-east-1:541623049223:execution:clarifi-appanalytics-ingestor-nightly-prd-rmm-json:e47d5f3c-5a74-64f8-1f46-b10f1b05b486_bf091c7d-2f6e-95b8-55ed-3c39ab56b1cb FAILED at 2021-08-07T05:15:41Z while processing policy 1234 for client SSN 111-11-1111
    ```

<br/>

* **Developers MUST consider potential data loss scenarios when using managed services**
    * e.g. dead letter queues, retry policies, etc.
    * Example 1: if a lambda is configured to process a SQS readMessage and that lambda throws an exception AWS will retry it only a limited number of times then eventually drop the message (thus leading to data loss).
    * Example 2: Incoming feed lambda listener throws exception while processing file could lead to file not being processed and thus resulting in data loss scenario

<br/>

* **Require server side encryption for any EBS volumes**

<br/>

* **Ensure default encryption is enabled in each account for EBS volumes**


<br/>

* **EBS snapshots should not be public accessible**

<br/>

* **EC2 instances should use IMDSV2 to protect instance metadata**

<br/>

* **Encrypt all data at the BUCKET LEVEL using AES-256**

<br/>

* **ALL S3 BUCKETS SHOULD NEVER BE PUBLIC!** 
    * Use bucket "Block public access" settings [more info here](https://aws.amazon.com/blogs/aws/amazon-s3-block-public-access-another-layer-of-protection-for-your-accounts-and-buckets/)


<br/>

* **AWS Workspaces should encrypt all volumes**

<br/>
