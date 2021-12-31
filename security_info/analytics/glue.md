# Glue

This page documents security considerations when using Glue.

# General Guidance/Information
Amazon Glue provides [security within the service](https://docs.aws.amazon.com/glue/latest/dg/infrastructure-security.html)

Additional notes:
* VPC endpoints can be defined to execute glue within but glue does NOT support VPC endpoint policies
* Glue SecurityConfiguration can be utilized to encrypt data written by glue jobs, book marks, etc.
* Glue DataCatalogEncryptionSettings can be utilized to encrypt catalog information.

# Policy
* All glue job data reading/writing from S3 use S3 buckets thus ensuring data encryption at rest by the default bucket policy
* Cloudwatch log data is assumed encrypted by default by the cloud watch service
* Any glue job definitions should NOT utilize hard coded passwords, tokens, etc. For example, product glue jobs reading information from Cassandra utilize AWS secrets manager for all connection info.
* All glue jobs permissions to all external services are handled via IAM role policies defined by ETS (see section below)

**TODO: need to figure out how other teams are specifying connection information**

**Open items include**
* Single Dev 'admin' role
* Glue data catalog encrypted at rest
* Job bookmark encrypted
* Developer endpoint security settings

## Vpc endpoint policy (ETS)
VPC endpoint policy are NOT supported by Glue

## Sample glue policy 
This sample policy demonstrates restrictions on:
* which specific services the jobs require to run (e.g. athena, glue, s3, etc.)
* which buckets the jobs read/write from
* which specific secrets the jobs have access too

```yaml
  PmlGlueExecutionPolicyproduct:
    Properties:
      Description: Defines Glue access for product
      ManagedPolicyName: PmlGlueExecutionPolicyproduct
      Path:
        Fn::Sub: /${AWS::AccountId}/${AWS::Region}/${AppEnv}/product/
      PolicyDocument:
        Statement:
        - Action:
          - athena:*
          - glue:*
          - s3:ListBucket           <!--  actions for S3 required>
          Effect: Allow
          Resource: '*'
        - Action:
          - s3:GetObject            <!-- permits S3 read/write/delete for jobs>
          - s3:PutObject
          - s3:DeleteObject         
          Effect: Allow
          Resource:
          - arn:aws:s3:::aws-glue-*/*
          - arn:aws:s3:::aws-athena-query-results-*/*
          # to product specific buckets only!
          - Fn::Sub: arn:aws:s3:::${AWS::AccountId}-${AWS::Region}-${AppEnv}-product-*/*
        - Action:
          - secretsmanager:GetSecretValue
          Effect: Allow
          # product specific secrets only
          Resource: arn:aws:secretsmanager:us-east-1:XXXXXXXXX:secret:product/dev/*
          Sid: GetSecrets
        - Action:
          - kms:Decrypt
          - kms:DescribeKey
          Effect: Allow
          # our KSM customer managed secret key!
          Resource: arn:aws:kms:us-east-1:XXXXXXXXXXXXX:key/6993eb28-3461-441b-beac-5f9e0dd5ebe6
          Sid: DecryptCmkSymmetricDev
        Version: '2012-10-17'
    Type: AWS::IAM::ManagedPolicy
```

## Sample secrets manager access

```scala
val cassandraSecrets = retrieveSecrets(secrets_key)
val host_names = cassandraSecrets.HOST_NAMES
val user_id = cassandraSecrets.USER_ID
val password = cassandraSecrets.PASSWORD

// secrets_key is job argument (e.g. arn:aws:secretsmanager:us-east-1:077544953943:secret:product/dev/cassandra/connection_dev-y3mltn)
def retrieveSecrets(secrets_key: String) :CassandraSecret = {
    val awsSecretsClient = AWSSecretsManagerClientBuilder.defaultClient()
    val getSecretValueRequest = new GetSecretValueRequest().withSecretId(secrets_key)   
    val secretValue = awsSecretsClient.getSecretValue(getSecretValueRequest)
    val secretJson = secretValue.getSecretString()
    val mapper = new ObjectMapper()
    mapper.registerModule(DefaultScalaModule)
    val cassandraSecret = mapper.readValue(secretJson, classOf[CassandraSecret])
    return cassandraSecret
}

```