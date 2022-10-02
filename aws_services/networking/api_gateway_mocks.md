# API Gateway Mocks
This page summarizes information on API Gateway Service mocking

## General
* Mock endpoints are only meant for smallish payloads. AWS recommends using Lambda for larger payloads to mock out.
* Mock endpoints use Template mappings to return mock payload. So this appears to be very static in nature.
* Still need to setup standard Method Response codes (200, 500, 201, etc.)
* You can use query string values to vary the returned HTTP status codes by adding logic to the integration response mapping template

```yaml
# In this example added a query string parameter 'scope' with different values to have API gateway return
# either 200, 201, or 500
{
  #if( $input.params('scope') == "internal" )
    "statusCode": 200
  #elseif ($input.params('scope') == "created")
    "statusCode": 201
  #else
    "statusCode": 500
  #end
}
```

* Mocked endpoint returning XML can not be tested using the API gateway testing UI (only JSON supported).
* Mocked endpoints can be configured to return XML
