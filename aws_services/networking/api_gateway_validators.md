# API Gateway
This page summarizes information on API Gateway Service Validation feature.

## General
* Validators can only be used for simple request data values by validating against JSON schema version 4 (http://json-schema.org/)
* Validators require HTTP request to have mapped model (JSON based) to validate against
* QueryStringParamters, HTTP Headers can only validate for presence and non-empty values (assume String)
* Body JSON validation supports more complex schema rules (string, integer, enum, max length, etc.)
```yaml
# sample JSON model schema definition for body values
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "GetStartedLambdaIntegrationInputModel",
  "type": "object",
  "properties": {
    "callerName": { "type": "string", "minLength": 2, "maxLength": 10 },
    "callerAge": { "type": "integer" },
    "callerSex": { "type": "string", "enum": ["Male","Female", "NA"] }
  }
}
```

* Error response returned is always 400 with a generic message **unless we configure the 400 gateway RESPONSE
```yaml
# Replace generic 400 error response with specific validation error message
{"message": "$context.error.validationErrorString"}
```
