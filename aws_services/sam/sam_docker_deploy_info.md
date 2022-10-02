# SAM Docker Deployment Info
This page summarizes basic info on how to use SAM to create lambdas using docker images.

## General Guidelines
To use a docker build need to specify some specific config template values and simple .toml file changes.

```yaml
# Sample template.yaml
Resources:
  EcsReaderFunction:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: !Join ["-", [!Ref EnvPrefix, "sam-python-ecs-reader"]]
      PackageType: Image                <--- want to use docker image
      ImageConfig:                      <--- docker image config info
        Command:
          - ecs_reader.lambda_handler
    Metadata:                           <-- docker specific settings
      Dockerfile: Dockerfile            <-- Name of dockerfile used to create image
      DockerContext: ./ecshelpers       <-- Folder containing code
      DockerTag: python3.9-v2           <-- What tag name? If don't specify get huge munged name!

```

```yaml
# sample samconfig.toml
[default]
[default.deploy.parameters]
image_repository = "xxxxxxx.dkr.ecr.us-east-1.amazonaws.com/sam-python-sample"  <- add image_repository

[tst.deploy.parameters]
image_repository = "yyyyyyyyy.dkr.ecr.us-east-1.amazonaws.com/sam-python-sample"  <- add image_repository
```

## SAM build/deploy
All other SAM build/deploy commands are the same

```bash
sam build

# Deploy to default 'dev' environment (if configured in .toml file)
sam deploy

# Deploy to 'tst' environment (assumes in different image repo)
sam deploy --config-env tst
```

## Multiple Functions in a single Docker Image
To have multiple lambda functions deployed into the same docker image follow these instructions:

* Modify the template.yaml file to have each function definition use SAME metadata but DIFFERENT docker commands
```yaml
HelloWorldFunction:
    Type: AWS::Serverless::Function
    Properties:
      PackageType: Image              <-- same docker config info
      ImageConfig:                     
        Command:
          - app.lambda_handler         <-- specific command to invoke this lambda
    Metadata:                          <-- same metadata
      Dockerfile: Dockerfile
      DockerContext: ./hello_world
      DockerTag: python3.9-v1

  HelloWorldFunction2:
    Type: AWS::Serverless::Function
    Properties:
      PackageType: Image              
      ImageConfig:                    
        Command:
          - app2.lambda_handler      <-- specific command to invoke this lambda
    Metadata:
      Dockerfile: Dockerfile           <-- same metadata
      DockerContext: ./hello_world
      DockerTag: python3.9-v1
```

* Also ensure all required python files are added to the single docker image w/in dockerfile!
```yaml
# use correct base python version
FROM public.ecr.aws/lambda/python:3.9

# need to ensure we copy over the correct files into the container
COPY *.py requirements.txt ./
```

* Need to include docker file definition to include all lambda code
```yaml
# sample Dockerfile

FROM public.ecr.aws/lambda/python:3.9

# need to ensure we copy over the correct python files into the container
COPY *.py requirements.txt ./

RUN python3.9 -m pip install -r requirements.txt -t .

# Command can be overwritten by providing a different command in the SAM template!
CMD ["ecs_reader.lambda_handler"]
```

## Notes/Issues
This section outlines anything specific found using SAM with docker images.

* Can use single docker image to group multiple lambdas together
* Image tagging issue: Apparently SAM will always 'munge' the image tag (aws/aws-sam-cli#2600) so we can't have clean images tags! This is a super huge restriction.

```yaml
docker images
## this is what SAM creates
helloworldfunction-7d10b7dc0248-python3.9-v1

## this is what I want and unable to do so! Major bummer!
python3.9-v1
```
