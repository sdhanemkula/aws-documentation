# SAM Template Info

## General Guidelines
* Utilize globals for common define/override template definitions (e.g. all lambdas are java11, tags, etc.) this helps with creating smaller easier to understand templates
```yaml
Globals:
  Function:
      Runtime: java11
      MemorySize: 512
      Tags:
        app_name: "product"
        app_env: !Ref CFNEnvPrefix
        app_tier: "3"
        team: "integrators"
```

* If deployment requires a mix of SAM and CF resources you must utilize a SAM template as the basis of the deployment
```yaml
# Need to include the SAM template headers
AWSTemplateFormatVersion: "2010-09-09"
Transform: AWS::Serverless-2016-10-31
```

* Utilize CF Parameters for injecting parameter values to SAM resources

* Since developer credentials do NOT permit creating IAM roles/policies all SAM templates must use existing IAM roles/policies in all template definitions
```yaml
StockCheckerFunction:
	Type: AWS::Serverless::Function
	Properties:
		Role: !Ref CFNLambdaIAMRole  # Existing role NOT newly created role by SAM
		## This approach will NOT work
		# Policies:
		#    - AWSLambdaExecute
		#    - Version: '2012-10-17'
		#      Statement:
		#        - Effect: Allow
		#          Action:
		#            - s3:GetObject
		#            - s3:GetObjectACL
		#          Resource: 'arn:aws:s3:::my-bucket/*'		 -->
```

* Utilize "Outputs" to output ARN values if Ansible scripts require outputted values
```yaml
Outputs:
		StockTradingStateMachineArn:
    		Description: "Stock Trading State machine ARN"
    		Value: !Ref StockTradingStateMachine
```
* Not all SAM templates support all the required properties (e.g. Events -> InputTransformers) and thus should be avoided

## Gotchas
* Not all SAM template field values types match Cloud Formation template value types (e.g. tags is map and Map in other!)
* Some SAM template resources do NOT support using existing IAM roles and thus must be scripting using CF NOT SAM for that resource. For example, in the StateMachine -> Events does NOT permit passing an existing IAM role to the Event resource
* SAM/CF Stack names must be unique within an account so a pattern must be developed if multiple team members are working on the same stack!
