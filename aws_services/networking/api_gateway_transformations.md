# API Gateway
This page summarizes information on API Gateway Service transformation features

## General
* API gateway **only support JSON -> JSON and JSON -> XML transformations!** There is no built in features permitting VTL to take a XML message and convert it to a JSON structured message (only limited to creating a single string of whole XML!)**
* Can NOT send raw XML directly to lambda functions!
* It does not parse XML content to modify it (e.g. no transforms, validations, etc.)
* You can take a JSON payload an map it to XML
* You must create the MethodResponse with the associated HTTP code BEFORE you create the Integration Response! (e.g. create 201 first then create and associate the mapping)

## Integration Response Mappings
* Limited to only 1 mapping template per Content-type/Response code (e.g. 200 application/json) requires a single template
* Can peek into output message and change response code to non 200 (e.g. 201 for created resource)

```javascript
# Sample VTL associated with Integration Response Mapping Template
# Peek into result JSON and look for "ReturnStatus:'Created' and change to 201"
#set($inputRoot = $input.path('$'))
#if($inputRoot.containsKey('returnStatus') && $inputRoot.returnStatus == 'Created')
#set($context.responseOverride.status = 201)
{
    "returnStatus" :$inputRoot.returnStatus
}
#end
```

* Can map python runtime exceptions to 500 error (and can configure the 500 Gateway response for standards if required)

```python
## Python code does this
raise RuntimeError("Unrecoverable Error")

# API Gate Method Integration Response => 500
Lambda Error Regex: Unrecoverable Error.*
```

* Can take existing JSON structure and map to new structure (must use velocity template language) to create Mapping template

```javascript
# VTL example: Take result JSON and change the JSON field names
#set($inputRoot = $input.path('$'))
{
  "return_name" : $inputRoot.name,
  "return_age" : $inputRoot.age,
}
#end

```

* Can take existing JSON and convert to XML for response
```javascript
# VTL example: Take JSON and change to XML
#set($inputRoot = $input.path('$'))
<User>
    <name>$inputRoot.name</name>
    <age>$inputRoot.age</age>
</User>
```

## Related Links
* [XML limited support article](https://medium.com/@arvindpalsingh/our-tryst-with-aws-api-gateway-and-xml-transformation-f51121e6b5c4)
* [XML limited support article](https://github.com/mwittenbols/How-to-use-Lambda-and-API-Gateway-to-consume-XML-instead-of-JSON)
* [XML limited support article](https://www.journaldev.com/10113/aws-api-gateway-and-aws-lambda-example)
