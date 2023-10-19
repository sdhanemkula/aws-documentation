# Infrastructure Protection/Nothing Backdoored Public
This page summarizes various guidelines related to the Infrastructure Protection pillar.

## Guidelines
Relevant guidelines to follow include:

* **All access to services is controlled via SSO/IAM/Role/Policy**
    * No one off users/accounts permitted
    * Having controls via SSO and our user/accounts follows same corporate standards/audits/etc.

<br/>

* **No infrastructure should ever be defined “public” by DEV in IaaC**
    * True “Public” resources must be managed by Admin team (e.g. API gateways, S3 buckets, etc.)
    * Rationale: limit potential security event by developer misconfiguration, etc.

<br/>

* **When using managed services ‘traffic’ should be contained w/in the single AWS account**
    * E.g. SQS queue traffic limited to single account, different queues for DEV/MOD/PRD, etc.
    * Exemptions are permitted but must be reviewed
    * Rationale: our core IAM strategy is account based so thus limiting traffic using same means provides additional layer of protection.

<br/>

* **Managed services with potential ‘public facing’ traffic or containing any PII data should be restricted to run in our VPC**
    * SQS, API Gateway, DynamoDB, etc.

<br/>

* **VPC Endpoints should be automatically created in all accounts for common AWS services (e.g. ApiGateway, SQS, Secrets Manager, etc.)**
    * [Listing of integrated VPC endpoint policy list](https://docs.aws.amazon.com/vpc/latest/privatelink/integrated-services-vpce-list.html)

<br/>

* **VPC Endpoints must be utilized for relevant AWS Services!**
    * API Gateway, SQS

<br/>

* **VPC flow logging must be enabled for all regions!**

<br/>

* **AWS 'default' VPC should restrict all public traffic!**

<br/>

* **Ensure no security groups permit ingress from public internet 0.0.0.0/0 to any management ports!**

<br/>

* **If VPC peering is used ensure to only include desired subnets and not entire VPC to VPC CIDRs (least permission approach)!**

<br/>

* **Any public elastic IP should be protected by AWS shield!**

<br/>

* **All EC2 security groups should not permit public access via management ports (e.g. SSH or RDP)!**

<br/>

* **All EC2 security group rules should populate description field indicating desired access**

<br/>

* **All EC2s should NOT have public IP**
    * Use ALB or equivalant for any public access

<br/>
