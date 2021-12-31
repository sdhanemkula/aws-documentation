# VPC Endpoints

This page summarizes relevant information on usage of vpc endpoints within our managed services.

## Common Terms

* **AWS PrivateLink:** is a highly available, scalable technology that enables you to privately connect your VPC to supported AWS services, services hosted by other AWS accounts (VPC endpoint services), and supported AWS Marketplace partner service. All vpc endpoints run using this service
* **Endpoint service:** Your own application or service within your VPC
* **VPC endpoint** entry point in your vpc lets you connet to AWS service 'privately'
* **VPC Endpoint Policy:** A VPC endpoint policy is an IAM resource policy that you attach to an endpoint when you create or modify the endpoint. If you do not attach a policy when you create an endpoint, we attach a default policy for you that allows full access to the service.

## VPC endpoint types
The VPC Endpoint types utilized depend on AWS service to connect to

* **Interface endpoints:** use private link, lots of service connections here
* **Gateway endpoints:**  don't use private link, example services are S3, dynamodb
* **Gateway load balancer**

## Restrictions to consider
* Must be in same region
* Can't be tranferred from one service or vpc to another

## usage
* VPC endpoints should be created by security/networking team (NOT Developers)

## Relevant Links

* [https://docs.aws.amazon.com/vpc/latest/privatelink/integrated-services-vpce-list.html](VPC endpoint policy to service listing)
	

