# Secrets
This page summarizes various guidelines related to the Secrets pillar.

## Guidelines
Relevant guidelines to follow include:

* **No hard coded users/passwords/API tokens/AWS tokens in code!**
    * Includes: source code, IaaC, Property files, etc.
    * Rationale: avoid security event by someone having access to our codebase

<br/>

* **Use secrets manager for secrets only and NOT for all parameter values**
    * User/password OK, URLs for service invocations NO
    * Rationale: secrets cost $$ and desire to have InfoSec manage the secrets so having more than secrets stored is more costly and prolematic

<br/>

* **Define separate secrets for each resource. Do NOT combine all secrets into a single JSON secret value.**
    * E.g. dev/ace/api_key, dev/Cassandra/connection
    * Do NOT do this: 
    ```json
        devClarifiSecrets 
        { 
            "secret1": "value", 
            "secret2" : "value2"
        }
    ```
    * Rationale: separate secrets permits easy audit, changes, monitoring

<br/>

* **Avoid storing mixed environment secrets in a single account**
    * Dev account secrets should be limited to dev secrets resources, etc.

<br/>

* **IaaC should only contain secret keys NOT values!**
    * Key is in Cloud formation, value should be looked up in code or by AWS managed service (e.g. ECS Fargate)
    ```
    # Do NOT do this in IaaC
    Type: AWS::Lambda::Function
    Properties:
      Environment:
        Variables:
          DB_PASSWORD: "myPassword"
    ```

<br/>

* **IaaC should utilize SSM parameters for resource specific values to secure resources**
    * Do not hard code these in IaaC since they may change during normal maintenance or security updates, etc.
    * IAM roles, VPC Ids, security groups, etc.
    ```json
    Parameters:
        CFNLambdaIAMRole:
            Type: 'AWS::SSM::Parameter::Value<String>'
            Default: /clarifi/Iam/PmlLambdaExecutionRoleClarifi
        CFNSubnetIds:
            Type: 'AWS::SSM::Parameter::Value<List<String>>'
            Default: /clarifi/vpc-us-east-1-dev-clarifi/SubnetsPrivateIds2
        CFNSecurityGroupId:
            Type: 'AWS::SSM::Parameter::Value<String>'
            Default: /clarifi/vpc-us-east-1-dev-clarifi/SecurityGroupLambdaAccess2
    ```

<br/>

* **Do NOT hard code secret keys into source code! Pass secret keys as params or env vars**
    * E.g. Lambda env vars, Glue job parameters, ECS environment vars
    * This forces a code change if any secret key names are changed or updated. 
    ```
    # DO NOT do this in code
    public static final String SECRET_KEY = "dev/cassandra/connection"

    # instead want to do this in IaaC (inject the key into the environment)
    Environment:
        Variables:
          SECRETS_KEY: "arn:aws:secretsmanager:us-east-1:XXXXXXXXXXXX:secret:dev/cassandra/connection-Me4geJ"

    # then in code read from env
    String secretKey = System.getenv(SECRETS_KEY)
    ```

<br/>

* **Do NOT log secrets manager API calls to cloud watch logs!**
    * Can inadvertantly be storing away secret values in our logs

<br/>


* **Secret replication across regions is not likely day one**

<br/>

