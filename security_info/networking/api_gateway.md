# API Gateway
This page summarizes information on API Gateway Service.

# General Guidance/Information
Amazon API gateway provides numerous means to control access.

* **Network** - Private gateways with resource policy to restrict NOT from VPC
* **authentication/authorization** - resource policies, IAM roles/policies, IAM tags, vpc endpoint policies, custom authorizors, cognito
* **access control** -> CORS, client SSL certs, AWS WAF

Please refer to the api gateway developers guide for more information.

# Policy
API gateway policy ensures:
* Private API gateway must include vpc endpoints
* Public API gateway must be managed by an OPS team!
* Private API gateway should restrict all traffic to only vpc endpoints (see policy below)
* Require API gateway to define a PRIVATE EndpointConfiguration only
```
      EndpointConfiguration:
        Type: PRIVATE
        VPCEndpointIds:
          - !Ref CFNVpcEndpointId
```

**Open items to resolve include:** 
* Client Certificate for SSL 
* Disable default execute-api endpoint entirely
* Encrypt API caching data
* Restrict execution to specific REST Verbs/routes
* Single Dev 'admin' role
* Ensure access logging enabled
* Public API gateway protected by WAF
* Method should NOT have AuthorizationType set to 'NONE'


## Vpc endpoint policy
VPC endpoint policy should be created for a given account. 

This policy grants:
* basic network access security
* basic service level action permissions permitting access to the 'execute-api:Invoke' action
* account level principal/resource access (e.g. all gateways in this account are connected to this vpc endpoint and ensure all principals have access to all resources)

```YAML
  VpcEndpointApiGateway:
    Properties:
      PolicyDocument:
        Statement:
        - Action:
          - execute-api:Invoke
          Effect: Allow
          Principal: '*'
          Resource:
          - '*'
      PrivateDnsEnabled: true
      SecurityGroupIds:
      - Ref: SecurityGroupApiGatewayEndpoint
      ServiceName: com.amazonaws.us-east-1.execute-api
      SubnetIds:
      - Ref: TransitGWAzA
      - Ref: TransitGWAzB
      - Ref: TransitGWAzC
      VpcEndpointType: Interface
      VpcId:
        Ref: VPC
    Type: AWS::EC2::VPCEndpoint
```


## Api gateway Auth:ResourcePolicy
This section documents various examples of how to restric access to a gateway


**Restrict any traffic NOT coming from our VPC**
```yaml
  Auth:
        ResourcePolicy:
          CustomStatements: [ {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "execute-api:/*/*/*",
            "Condition": {
              "StringNotEquals": {
                "aws:sourceVpc": !Ref CFNVpcId
              }
            }
          } ]
```