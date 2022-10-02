# SAM CLI Info

## General Guidelines
* SAM you are required to override numerous values if using the CLI commands. Need to investigate utilizing IAM permission boundaries as an alternative to this restriction in the future.

| permission | work around |
| -- | -- |
|Create S3 bucket for code  | override SAM default s3_bucket location |
|Create IAM/POLICY   | utilize PM IAM roles for all resources NOT existing SAM policy templates  |

* Utilize the 'sam build' and 'sam validate' commands to ensure template syntax is linted correctly
* Utilize a samconfig.toml file to define common deployment properties
```yaml
version=0.1
[default.deploy.parameters]
region = "us-east-1"
stack_name = "sam-poc-stack"
```

* You can use sam configuration files to provide default arguments to other commands!
```yaml
version=0.1
[default.deploy.parameters]
stack_name = "sam-poc-stack"
[dev]
[dev.deploy.parameters]
stack_name = "sam-dev-stack"
s3_prefix = "sam-dev"
```
```bash
# invoke build using dev values
sam build --config-env dev
# invoke log call with same values
sam logs --config-env dev
```

* You must configure SAM for the location of the 'code/deploy' bucket to utilize (e.g. within samconfig) (so doesn't create the bucket for you)
```yaml
# informs SAM to put all deployment 'code' and 'template' files in the bucket/prefix locations
[default.deploy.parameters]
s3_bucket = "us-east-1-dev-my-sam-code"
s3_prefix = "my-sam-poc"
```

* You can view the deployed code after a SAM deploy by inspecting the generated template in S3 and the specific resources CodeUri: values
```yaml
## deployed template with SAM deployed lambda location
StockCheckerFunction:
  Type: AWS::Serverless::Function
  Properties:
    CodeUri: s3://us-east-1-dev-code/product-sam-poc/036bad6fb740db9c07a49343b13ef244
```
```
## In a Java deployment example you can download the file at that location (add a .zip to it and extract it to view the entire deployed artifact for the lambda /lib/jars src/*.class files)
```

## Gotchas
* SAM deployments are limited to passing CF params as command line args string only. This can be very troublesome if have lots of VARS. There is an existing issue on this item https://github.com/awslabs/aws-sam-cli/issues/2054
```
# invoke SAM deploy and modify the default 'CFNEnvPrefix' parameter value to be 'dev2'
sam deploy --profile productDEV --parameter-overrides "CFNEnvPrefix=dev2"
```

* SAM cli commands utilize telemetry to write information to buckets (across regions possibly!) which devs do NOT have access to! This results in SAM CLI command errors. This can be suppressed by adding this suppression bash sessions
```bash
export SAM_CLI_TELEMETRY=0
```

* SAM 'build' defaults package each lambda as a separate deployment unless CodeUri, runtime, and build metadata are the same! So for Java based builds not following this could lead to builds which run All the tests for every single lambda!

## TBD Items
* SAM CLI commands assume all source code AND IaaC are in same project. Location of IaaC within existing source is still TBD.
* Utilizing SAM 'build/deploy' for ENTIRE build workflow is still TBD. Assumption is developers could use 'sam build' locally but may require maven/jenkins based build/deploy for actual deployments

* SAM 'build/deploy' does NOT appear to be able to connect to Nexus to pull artifacts. Assume this must be handled via Maven

