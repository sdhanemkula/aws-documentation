# API Gateway Lambda Integration
This page summarizes information on API Gateway Service with Lambda integration.

## General
* There are two means for integrating lambda with API Gateway (Lambda Proxy, Lambda Non-Proxy)
* Deciding on which integration pattern is dependent upon project requirements (e.g. how much HTTP do I want my code to deal with?)

## Lambda Proxy Integration
* Utilize this method when the gateway is just passthrough mapping of all HTTP to Lambda
* Can use Models to document both API and for validation but not sure how used for Method Response
* Can map query string parameters and HTTP headers for basic validation
* Requires very minimal setup on the Gateway
* Requires lambda to pull out the various HTTP values from the event object or use a framework to handle this for us

```
# Python example
# look into query string parameters for values
queryStringParameters = event.get('queryStringParameters', None)
if queryStringParameters:
    if queryStringParameters.get('name', None):
        name = queryStringParameters['name']

    if queryStringParameters.get('city', None):
        city = queryStringParameters['city']

# look into headers for day portion
event_headers = event.get('headers', None)
if event_headers:
    day = event_headers['day']

# look into body for json payload
if event.get('body', None):
    body = json.loads(event['body'])
    bodyStr = str(body)
```

## Lambda Non-Proxy
* Requires much more setup on Gateway (e.g. models, methodRequest, IntegrationRequests, MappingTemplate, etc.)
* Gateway performs validation/transformation BEFORE having to invoke lambda (saves on application logic, lambda costs)
* Lambda code just deals with context, event as flat dictionary of values not real HTTP required at all.

```
# python example
# city is query string parameter, time is HTTP header value, name,age are values form JSON body element
name = event.get('name', 'TestName')  # from JSON body
city = event.get('city', 'TestCity')  # from query string parameter
time = event.get('time', 'TestTime')  # from HTTP header value

```
