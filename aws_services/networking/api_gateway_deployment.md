# API Gateway Deployment Documentation
This page summarizes information on API Gateway Service deployment options assuming IaaC is required.

## General
* The amount of resources/endpoint/features utilized by an application team directly corresponds to the amount and complexity of the required IaaC to deploy and API gateway. For example, a gateway only using lambda proxy invocations with 5 or less resources is much less complex than a gateway using lambda non-proxy invocations with the same amount of resources.
* There is no current way to restrict having developer teams create public API gateways! As a result, teams must be congnizant NOT to create public gateways.

## Open API w/AWS extensions
* Use full baked OpenAPI specification with AWS extensions to define all integrations/features used
* Large yaml files are pretty much unmaintainable
* splitting files into multiple parts (requires swagger-cli to merge together). More information is [here](https://davidgarcia.dev/posts/how-to-split-open-api-spec-into-multiple-files/) and [here](https://producement.com/blog/managing-openapi-specification/) and [here](https://stoplight.io/blog/keeping-openapi-dry-and-portable)
* Unfortunately if try and breakdown large Open API definition file into to smaller files most tooling doesn't work [info here](https://github.com/42Crunch/vscode-openapi/issues?utm_source=vsmp&utm_medium=ms%20web&utm_campaign=mpdetails) and [here]([https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi) and [here](https://github.com/42Crunch/vscode-openapi/issues/82)
* Can try and use IDE like spotlight studio but [costs $$$](https://stoplight.io/pricing/) or could use [swagger](https://swagger.io/tools/swagger-editor/)
* AWS extensions are really hard to decipher and include lots of code for transformation logic
* VTL code is represented as a JSON string thus is super messy!


## Cloud Formation
* Use standard cloud formation for all API gateway component definitions.
* This approach does not include API documentation unless specified using document parts
* Overly verbose compared to open api specification [comments here](https://nickolaskraus.org/articles/creating-an-amazon-api-gateway-with-a-lambda-integration-using-cloudformation/)
* Single large cloudformation template is problematic. Probably need to break out templates via Ansible/Jinga
* VTL code is represented as a JSON string thus is super messy!

## SAM
* SAM approach uses some serverless extensions combined with most of the details being mapped out in the OpenAPI w/AWS extensions specifications.
* AWS::Serverless::Api (basic properties only – stage, gateway responses). If an AWS::Serverless::Api resource is defined, the path and method values MUST correspond to an operation in the OpenAPI definition of the API. If no AWS::Serverless::Api is defined, the function input and output are a representation of the HTTP request and HTTP response.
* AWS::Serverless::Function event “Api” type provides basic integration of lambda with API route/path
* Relies upon Open API w/Extensions for most of the hard stuff though (models, mappings, templates, etc.)
* Provides easy way to link up the Lambda functions with the API defs in OpenAPI spec
