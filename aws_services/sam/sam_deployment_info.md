# SAM Deployment Info

## General Guidelines
* Utilizing SAM 'build/deploy' for ENTIRE build workflow is still TBD. Assumption is developers could use 'sam build' locally but may require maven/jenkins based build/deploy for actual deployments
* SAM 'build/deploy' does NOT appear to be able to connect to Nexus to pull artifacts. Assume this must be handled via Maven
* SAM CLI commands assume all source code AND IaaC are in same project. Location of IaaC within existing source is still TBD.
* Deploying SAM templates requires IAM role CreateChangeSet permissions which is NOT automatically in dev IAM role
* If using Maven based artifact builds the SAM templates must use the CodeUri: pointed to the location of the artifact
```
Type: AWS::Serverless::Function
    Properties:
      CodeUri: s3://us-east-1-dev-code/product-sam-poc/myLambdaJar.jar
```

## Ansible Notes
* Ansible's cloudformation module can be utilized to depoy SAM templates with minor changes
```
# Sample cloudformation module call for a SAM template.
# Note: the additional capabilities are required for SAM deployments
cloudformation:
  stack_name: "sam-poc-stack"
  state: "present"
  region: "us-east-1"
  disable_rollback: true
  capabilities:
    - CAPABILITY_IAM
    - CAPABILITY_AUTO_EXPAND
  template: "/SamSampleTemplate.template"
  template_parameters:
    CFNEnvPrefix: "dev"
register: sf_cf_outputs
tags: lambda
```

## TBD Items
* Mentions Jenkins deploy (https://plugins.jenkins.io/aws-sam/) for package and deploy steps but this is still TBD

