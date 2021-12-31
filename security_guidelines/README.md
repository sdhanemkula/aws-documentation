# AWS Security Guidelines
This project contains all relevant AWS security related guidelines for using MANAGED SERVICES within AWS.

These questions/guidelines were developed over time when building various projects w/in AWS as well as security reviews, etc.

Developers should utilize this info when familiarizing themseles with using various AWS managed services and how they should be applying security w/in their usage in applications.

The guidelines are categorized using a combination of the AWS security pillars w/additional relevant security categories.

* **Identity & Access Management/Least Privilege** - How are ensure the least amount of access w/in our applications?
* **Detective Controls** - What detective controls do we require to ensure proper security monitoring/responding to events?
* **Infrastructure Protection/Nothing Backdoored** - How are we protecting our infrastructure?
* **Data Protection** - How are we protecting our data?
* **Secrets** - How are ensuring our secrets are private?
* **Deployment** - How are ensuring our deployments are secure?


## Documentation Standards

* Each section contains two files: question.md and guidelines.md


## References
This section provides important links related to these guidelines.

* [AWS well architected security pillars doc](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html) - AWS documentation for how to design a well architected application in regards to security
* [AWS IAM Service actions, resource, condition key listing](https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html) - lists all the various AWS managed services and the corresponding actions/resources/conditions which can be used when making policies, etc.
* [AWS Audit trail topics/integrations reference](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-aws-service-specific-topics.html#cloudtrail-aws-service-specific-topics-integrations) - central page providing information on what managed services' actions are permissible to configure for cloud trail
* [AWS VPC endpoint managed service listings](https://docs.aws.amazon.com/vpc/latest/privatelink/integrated-services-vpce-list.html ) - central page listing which managed services permit VPC endpoints, policies, etc.



	
