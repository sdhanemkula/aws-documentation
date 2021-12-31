# Athena

This page documents security considerations when using Athena.

# General Guidance/Information
Amazon Athena provides [security within the service](https://docs.aws.amazon.com/athena/latest/ug/security.html)

Additional notes:
* VPC endpoints can be defined to execute within and do support VPC endpoint policies
* Athena is a primarily 'read only' service (does write query-results to s3 bucket)
* Athena workgroups can be defined to assist in minimal user configuration values

# Policy
* All Athena access permissions (services) to all external services are handled via IAM role policies defined by ETS (see section below) 
* All Athena access permissions (business users) are handled via IAM role policies defined by ETS (see section below)

**TODO: need to figure out how other teams are specifying connection information**

**Open items include**
* Single Dev 'admin' role
* Athena workgroup security settings
* Athena schema information encryption (e.g. Glue Data catalog)
* Athena running [within a VPC interface endpoint and glue vpc endpoint](https://docs.aws.amazon.com/athena/latest/ug/interfvpc-endpoint.html)

## Vpc endpoint policy (ETS)
VPC endpoint policy are supported by Athena but currently NOT used by development teams

## Sample athena IAM policy (service based)
This sample policy demonstrates a lambda with restrictions on:
* which specific services queries are required to run (e.g. athena, glue, s3, etc.)
* which buckets the queries read/write from

```yaml
  PmlLambdaAthenaSnsExecutionPolicyproduct:
    Properties:
      Description: Allows Lambda to access Athena, SNS resources
      ManagedPolicyName: PmlLambdaAthenaSnsExecutionPolicyproduct
      Path:
        Fn::Sub: /${AWS::AccountId}/${AWS::Region}/${AppEnv}/product/
      PolicyDocument:
        Statement:
        - Action:
          - athena:*
          - glue:*
          Effect: Allow
          Resource: '*'
        - Action:
          - s3:DeleteObject         <!--  S3 access for reading from product buckets, query results>
          - s3:GetObject
          - s3:PutObject
          Effect: Allow
          Resource:
          - arn:aws:s3:::aws-glue-*/*
          - arn:aws:s3:::aws-athena-query-results-*/*
          - Fn::Sub: arn:aws:s3:::${AWS::AccountId}-${AWS::Region}-${AppEnv}-product-*/*
        - Action:
          - s3:GetBucketAcl
          - s3:GetObject
          - s3:GetObjectAcl
          - s3:GetObjectVersion
          Effect: Allow
          Resource:
          # Lambda is only allowed to read from these buckets
          - arn:aws:s3:::us-east-1-prd-product-raw
          - arn:aws:s3:::us-east-1-prd-product-raw/*
          Sid: AllowReadOnlyAccessproductPrdS3raw
        - Action:
          - kms:Decrypt
          - kms:DescribeKey
          Effect: Allow
          Resource: arn:aws:kms:us-east-1:077544953943:key/6993eb28-3461-441b-beac-5f9e0dd5ebe6
          Sid: DecryptCmkSymmetricDev
        Version: '2012-10-17'
    Type: AWS::IAM::ManagedPolicy
```

## Sample IAM Policy (Business User - SSO permission set)
This permission set outlines access a sample business user has:
* Athena related permissions (e.g. athena:*, S3)
* specific resource (which buckets allowed etc.)

```yaml
  AwsBusproduct:
    Properties:
      Description: product business permissions
      InlinePolicy: '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow",
        "Action": [ "athena:*" ], "Resource": "*" }, { "Effect": "Allow", "Action":
        [ "s3:GetObject", "s3:GetObjectAcl", "s3:PutObject", "s3:PutObjectAcl", "s3:DeleteObject"
        ], "Resource": [ "arn:aws:s3:::aws-athena-query-results-*/*", "arn:aws:s3:::*-product-*/*",
        "arn:aws:s3:::prod-us-east-1-product-raw/*", "arn:aws:s3:::prod-us-east-1-product-udl/*",
        "arn:aws:s3:::prod-us-east-1-product-code/*" ] }, { "Effect":
        "Allow", "Action": [ "s3:GetAccountPublicAccessBlock", "s3:GetBucketAcl",
        "s3:HeadBucket", "s3:ListAllMyBuckets", "s3:ListBucket" ], "Resource": "*"
        } ] }'
      ManagedPolicies:
      - arn:aws:iam::aws:policy/AmazonAthenaFullAccess
      Name: AwsBusproduct
      SessionDuration: PT4H
    Type: AWS::SSO::PermissionSet
```