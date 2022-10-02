# Cloud Formation Usage

## General Guidelines

* Utilize Cloud Formation templates to define all AWS resources where possible! This ensure a much easier, atomic deployment of AWS resources.

* Creating dependencies between stacks is nice but can cause issues when coding/updating. For example, you must delete stack X before can delete stack Y since X depends on Y

* CloudFormation cloud watch templates don’t support tagging cloud watch resources so must tag these resources using Ansible

* Define stack names using existing naming standards from tech ops team. Stack execution IAM roles utilize stack names to grant privileges (e.g. ingestor-us-east-1-product-step-functions)

## Template Guidelines

* Define Templates in YAML not JSON. JSON gets super messy and YAML is super clean

* CloudFormation template size limit is 56K so ensure all templates fit and decompose into smaller if necessary

* Do NOT change a resource name within a template definition! This confuses CloudFormation and will potentially corrupt your stack!
```yaml
Resources:

  CFNStepFunctionsDoNOTChangeMe:
    do NOT rename the resource name above!
```

* Output ARNs from CloudFormation stacks if needed in Ansible scripts
```yaml
Outputs:
  CFNStepFunctionsNightlyRaJsonResult:
    Description: Step Functions Arn
    Value: !Ref CFNStepFunctionsNightlyRaJson
```

* Utilize the AWS Systems manager store for OPS dependencies like IAM, VPC, etc.
```yaml
Parameters:
  CFNStepFunctionsIAMRole:
    Type: 'AWS::SSM::Parameter::Value<String>'
    Default: /product/Iam/PmlStepFunctionsExecutionRoleproduct
```

* Avoid using AWS Specific Parameter Types due to required extra IAM configuration
```yaml
## defining a parameter of this type now requires all executors to have extra EC2/IAM permissions
Parameters:
  CFN:
    Type: AWS::EC2::AvailabilityZone::Name
    Default: myAvailabilityZone
```

* Decompose large templates into smaller manageable templates using a combination of Ansbile and cloud Formation
```yaml
# This example is a single template to create an entire Athena database with all table definitions
# All table definitions are separate .j2 file included into the larger .j2 file
# The ensures smaller separate templates for easier development/supportability
Resources:

  # Create EMSI Data Files Table (NOTE: using Jinja to include the dependent template)
  CFNTableEMSIDataFiles:
    {% include "./templates/cf/raw/tables/raw_table_emsi_data_files.j2" %}

  # Create EMSI Issue Files Table (NOTE: using Jinja to include the dependent template)
  CFNTableEMSIIssueFiles:
    {% include "./templates/cf/raw/tables/raw_table_emsi_issue_files.j2" %}
```

* Using Cloud Formation Parameters vs. Ansible template variable is TBD. There are tradeoffs to both approaches for defining dynamic variable resources within a template.

## Component Specific Guidelines

* Stacks defining Lambdas within a VPC take forever to delete! (30 minutes). There is an AWS issue with lambdas and ENI creation/destruction

* Deleting GLUE stacks destroys all glue jobs/history!
