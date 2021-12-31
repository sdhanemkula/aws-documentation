# SAM Local Testing Info

## General Guidelines
* When testing locally you need to understand the limits of 'same local invoke' and any other Local container services you're using (e.g. AWS Local DynamoDB, LocalStack, etc.).
  * SAM local supports lambdas, API gateway calls
  * SAM local does NOT support local DynamoDB or S3

* SAM local mode does NOT mock out all AWS services! So if running lambdas locally via 'sam local' all lambdas' dependencies must either be mocked out (LocalStack or AWS Local) or be executed with a valid AWS terminal session configured with access keys.

* 'sam local generate-event' is nice for creating payloads to simulate what gets sent to your lambdas!

```
# generate a sample S3 'PUT' event
sam local generate-event s3 put

# generate a sample API call (GET hello/world)
sam local generate-event apigateway aws-proxy --method GET --body "" --path "hello/world"

# Can pipe out event output as input to lambda invocation!
sam local generate-event s3 put --bucket myBucket --key myKey | sam local invoke -e - myS3LambdaFunction
```

* Use local environment json files to configure all lambda's environment variables

```
# sample file contents
{
   "S3ReaderFunction": {
       "S3_ENDPOINT_URL": 'http://docker.for.mac.localhost:4566',
       "SECRETS_KEY": "secret",
       "BUCKET_FOLDER_ROOT_ITERATOR": "sampleS3Files",
       "BUCKET_NAME": "000000000000-us-east-1-dev-sam-poc-local",
       "BUCKET_REGION": "us-east-1"
    }
}

# Then invoke using --env-vars argument
sam local invoke S3ReaderFunction -e ./functions/S3Reader/sampleEvent.json --env-vars ./functions/sampleEventEnv.json

```

## Gotchas
* invoking services running docker container on mac need to use endpointUrls
```
"http://docker.for.mac.localhost:4566" // mocked S3 service from LocalStack
"http://docker.for.mac.localhost:8000", // Local DynamoDB service
```  

* SAM only reads the environment variables defined in the SAM template file not what's actually passed in the environment.json file!

```
# environment file defines two values
{
   "S3ReaderFunction": {
       "S3_ENDPOINT_URL": "some_value",
       "SECRETS_KEY": "secret that is never read"
  }
}

# SAM template only defines 1 argument
S3ReaderFunction:
  Type: AWS::Serverless::Function
  Properties:
    Environment:
      Variables:
        S3_ENDPOINT_URL: !Ref CFNS3EndpointApi  // NOTE ONLY 1 ENV VAR

# SECRETS_KEY is never read by lambda even though it's technically in 'environment' when using the CLI!
```
