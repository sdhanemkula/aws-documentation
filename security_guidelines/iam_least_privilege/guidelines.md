# IAM Least Privilege 
This page summarizes various guidelines related to the Identity and Access Management pillar.

## Guidelines
Relevant guidelines to follow include:

* **Developer IAM roles in DEV accounts permitting Admin/CRUD access to managed services will be restricted in QA/PRD accounts**
    * E.g. As a developer I can create a queue in DEV but NOT in QA/PRD. In those environments Jenkins should be only means for creating the resource.

<br/>

* **Developer IAM roles in QA/PRD accounts will have limited managed service resource permissions to their created resources**
    * E.g. Support Developer in QA/PRD can only read items from Read Items in DynamoDB
    * E.g. Support Developer in QA/PRD may Put/Delete objects from S3
    * In some support roles it is required to be able to delete/add some prod data or re-run jobs, lambdas to fix things

<br/>

* **Developer access to AWS PRD accounts will be limited and still TBD**
    * E.g. subset of leads only? Temp role creation? 

<br/>

* **Managed services used within QA/DEV AWS accounts should be designed with the same security constraints as PRD!**
    * HTTPs for transport, data encryption at rest, etc.

<br/>

* **RDS resources are managed by DBA team**
    * e.g. Oracle DB/tables etc. managed by DBA NOT developers

<br/>

* **Developers should review least privilege settings with security personnel before attempting to define their own resource policies**
    * e.g. IAM role/VPC Endpoint policies may already protect resource correctly for you
    * Rationale: developers may want to secure things better but may not understand what's already being locked down for them via VPC or IAM.

<br/>

* **When designing service role permissions, use fine grained permissions with following services:**
    * S3 (e.g. bucket A can only be read from these specific IAM roles NOT all roles)
    * DynamoDB (TBD: DEV must work with InfoSec/DBA to finalize our policy here)
    * Rationale is these services can be truly public, typically used to provide senstive data thus locking down as specific as possible is strongly desired.

<br/>

* **Use fine grained permissions with any PUBLIC facing managed service which is truly public**
    * e.g. public SQS queue uses fine grained whereas internal recommended but not required
    * Rationale is everything public needs highest level of security scrutiny.

<br/>

* **Developers should NOT design applications requiring runtime application code to create AWS resources dynamically “on the fly”.**
    * e.g. running service code should NOT be required to define/create a SQS queue, DynamoDB table, lambda during its execution
    * Rationale: creating queues, buckets, tables on the fly is an extremely security dangerous

<br/>


