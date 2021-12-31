# Cloudformation Guard

AWS cloud formation security tool (https://github.com/aws-cloudformation/cloudformation-guard) used for dev sec ops related checking of IaaC w/in a build process.

**Overall it was found to be much easier to use a tool like checkov rather than cloudformation guard!**

## General Findings
This section lists general findings using cloud formation guard.

* No OOTB checks (unlike checkov which has a rich set)
* Provides a unit testing framework (nice!!!)
* Uses a DSL query like language for writing rules (uses a DSL). This language appears to be quite confusing and not sure a basic sec engineer would be able to use it
* Unsure how to create complex rules using the DSL (since it's very query based). It was deemed so much easier to use checkov since those rules are basic python logic
* See known limitations section for more info!
* Can also use this tool to create basic architecture checks (doesn't have to just be security related!)

## Development environment setup
Refer to the cloudformation-guard github site for how to download and configure the tool for local use.

```bash
$ brew install cloudformation-guard
```

## Running sample Validation commands
To run various checks against templates use the 'validate' command.

```bash
# run all checks found in rules/basic against all files in the sample_templates directory
cfn-guard validate --data sample_templates --rules rules/basic

# run the specific template against all basic checks
cfn-guard validate --data sample_templates/gid_template.yaml --rules rules/basic

# run the template with all (output to Json format)
cfn-guard validate --data sample_templates/gid_template.yaml --rules rules/basic -o json
```

## Running sample unit tests
To run various unit tests for each type use the 'test' command

```bash
# run tests against basic sqs
cfn-guard test -r rules/basic/sqs_ensure_encryption.guard -t tests/basic/sqs_ensure_encryption_tests.yaml
```

## Known limitations/questions
This section lists any relevant findings
* SAM template guards will be slightly different than pure Cloud formation template files (e.g. AWS:Lambda:Function != AWS::Serverless::Function) so need to be super specific on the properties we're guarding for (e.g. Name is OK for both but not others)
* Jekins build integration is at the 'process' level only (e.g. exit code 1 vs. 0)
* Validations require well formed template files (e.g. ansible template .j2 files problematic)
* Validations only work on the exact file so if the template uses cloud formation parameters in some values these are NOT evalulated during the validation process!
```
Parameters:
  CFNEnvPrefix:
    Type: String
    Default: dev

Resources:
    Type: AWS::Lambda::Function
        Properties:
            FunctionName: !Join ["-", ["clarifi-archiving", !Ref CFNEnvPrefix]]  <== not able to put validation here

```
* Ansible based projects would need to design around using this tool to validate errors! For example, if a build has multiple CF files via ansible for each component of architecture during the deployment process this would have to be redesigned to have three steps: generate templates, run validation, deploy templates
* Valdation output is messy/confusing. In order to get something somewhat cohesive I grouped all the rules into a single dev rule file so I could see an easier output. Having them in separate .guard files made it messy.
* Can only run unit tests one at a time. 
* Unit test output is messy and hard to find errors.
* Doesn't support "short-form" of intrinsic functions (e.g. !Join, !Sub) docs state to use Fn::Join or Fn::Sub instead.
* validations don't handle resolving SAM template 'Globals'
```
Globals:
  Function:
    Timeout: 900

Resources:
  FileCheckerFunction:
    Type: AWS::Serverless::Function
    Properties:
     Name: blah
     **** <--  If there was a function check for Timeout this would NOT be found!
```
* Validation errors don't easily indicate which item in CF caused the failure. So having lots of elements where only 1 causes the failure can make debugging the single failure difficult.

## Sample rule definition
Listed below is a sample rule definition to demonstrate how to use cloudformation guard.

```
#
# Sample guard policy to ensure no EventBus elements exist with a policy permitting public access 

#
# Rule intent 
# A) All EventBridget Bus instances don't open access
#
# Expectations:
# 1) SKIP when there are no EventBus instances in the template
# 2) PASS when ALL EventBus instance have:
#               SNS Policy document not permitting global access
# 3) FAIL otherwise
#

# Select from Resources section of the template all EventBus 
#
let event_bus_policies = Resources.*[ Type == 'AWS::Events::EventBusPolicy' ]

let invalid_principals = ["*", ""]

rule event_bus_policy_not_permitting_global_access when %event_bus_policies !empty {
    %event_bus_policies {
       some Properties.Statement[*] {
            Principal.AWS[*] not in %invalid_principals
            Effect == "Allow"
        }
    }
}
```


## TODO
Items requiring followup include:
* Jenkins integration - how to add to jenkins and see if there's a failure?
* Policy repo - Where do we store these policy files for all builds to use?
* Create a lambda that fires on cloudformation stack push (to check and stop deploy or not)