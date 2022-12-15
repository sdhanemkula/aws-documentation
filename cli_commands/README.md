# CLI Commands Section

This section provides samples of various CLI commands across the various services

Notes:

* This folder contains numerous markdown files based on each aws_service type
* These pages will be organized based on service_type/service (e.g. analytics/athena.md, compute/ec2.md, application_integration/stepfunctions.md, etc.)
* Most queries assume [jq is installed on the machine](https://stedolan.github.io/jq/manual/)


## Running multiple accounts (personal and work)
At times I need to use my work account and also include connecting to my personal account and I don't want to mix the streams
by keeping everything in a single .aws directory config.

I will keep a copy on my laptop w/in a different directory called .aws_myuser 

```bash
### set these env vars in bash shell and I can run stuff in my personal account
export AWS_CONFIG_FILE=/Users/myserUName/.aws_myuser/config
export AWS_SHARED_CREDENTIALS_FILE=/Users/myUserName/.aws_myuser/credentials
export AWS_CA_BUNDLE=/Users/myUserName/.aws_myuser/cacert.pem
```

##### SSL error when running locally from connected work machine!!!
* Had to add the zscaler.pem file to the cacert file from the AWS site.
    * keychain access => system root => export zscaler root CA as .pem file
* follow instructions (to get a cacert.pem file locally)[https://github.com/aws/aws-sam-cli/issues/1930]
* take the zscaler file and append to the cacert.pem file
* copy that to my local .aws_myuser directory
* create ENV variable so can run cli/sam commands