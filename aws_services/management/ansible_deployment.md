# Ansible Deployment

## General Guidelines
* Utilize playbooks to group together an application deployment (e.g. ingestion is one playbook, transformation is another playbook)

* Use Ansible roles to logically separate out each component within the playbook (e.g. S3, DB, glue_jobs, etc.) and follow predefined folder structure!
```
my_role
	defaults	(role level global vars)
	tasks		(role level tasks)
	vars		(role level vars - env specific DEV,MO,PROD)
	templates	(role level templates)
	files		(role level files)
```

* Use Ansible tags on tasks to facilitate easier/faster component level deployments (e.g. code_deploy only refreshes source code)

* Utilize Cloud Formation templates to define all AWS resources where possible! This ensures a much easier, atomic deployment of AWS resources. If not using cloud formation try and ensure all roles are idempotent if possible

* All playbooks should be runnable across AWS account environments (e.g. values should not be hard coded specific to a certain AWS account!). Utilize Ansible variables and vars to separate out DEV,MO,PROD values

* For missing AWS Ansible modules utilize Ansible command and the aws cli (and JSON input where applicable)

```
- name: Create step function state machine (Nightly Risk Assessments)
  command: >
    aws stepfunctions create-state-machine
    --name "{{step_functions_state_machine_name_risk_assessments}}"
    --role-arn "{{step_functions_IAM_role_ARN}}"
    --definition ' {{step_function_json_definition_risk_assessments | to_json }}'
  register: step_functions_create_results_risk_assessments
```


## Naming Standards
* Variable names should be prefixed by role_name (e.g. code_deploy role variables should start with 'code_deploy_' default_bucket_name')

* Variables truly global to a playbook should start with default_ (e.g. default_environment_name)

## Dependencies
* All OPS dependencies should be looked up using SSM parameters and NOT hard coded! Work with the OPS resource to determine required dependency lookup names.

```
# IAM role
"{{product_glue_iam_role_name}}"
# security group id
"{{product_glue_security_group_ids}}"
```

* Make sure all dependencies are retrieved from Nexus!

```
## example maven_artifact call using nexus repo
- name: Download all Required Dependent JARS
  maven_artifact:
    group_id: "{{item.value.group_id}}"
    artifact_id: "{{item.value.artifact_id}}"
    version: "{{item.value.version}}"
    repository_url: https://nexus.com/repository/central/

## Do not do this
  maven_artifact:
    group_id: "{{item.value.group_id}}"
    artifact_id: "{{item.value.artifact_id}}"
    version: "{{item.value.version}}"
    repository_url: http://central.maven.org/maven2/
```


## Output
* When looping over multiple values utilize the 'loop_control' tag to provide better debug messages

```
# Ansible to loop through a dictionary
  aws_glue_job:
    name: "{{default_environment_prefix}}-{{item.key}}"
  loop: "{{glue_transformation_classes_dictionary_result_details|dict2items}}"
  loop_control:
    label: "{{ item.key }}"

# will output debug messages like this
[localhost] => (item=TransformPolicySummary)
[localhost] => (item=TransformPolicyRequirements)

```
