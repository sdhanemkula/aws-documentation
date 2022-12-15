# Elastic Container Repository

These are ECR related cli commands

```bash
## list all ecr repos
aws ecr describe-repositories --query 'repositories[].{repositoryName: repositoryName, repositoryArn: repositoryArn}' --output table

--------------------------------------------------------------------------------------------
|                                   DescribeRepositories                                   |
+--------------------------------------------------------------------+---------------------+
|                            repositoryArn                           |   repositoryName    |
+--------------------------------------------------------------------+---------------------+
|  arn:aws:ecr:us-east-1:XXXXXXXXXX:repository/example-terraform      |  example-terraform     |
|  arn:aws:ecr:us-east-1:XXXXXXXXXX:repository/example-platform-base  |  example-platform-base |
+--------------------------------------------------------------------+---------------------+

## see our docker images tags (e.g. example-terraform)
aws ecr describe-images --repository-name example-terraform --query 'imageDetails[].{digest: imageDigest, tags: imageTags}' --output table

## see our docker image tags (e.g. example-platform-base)
aws ecr describe-images --repository-name example-platform-base --query 'imageDetails[].{digest: imageDigest, tags: imageTags}' --output table

## show all images and tags (ugly table format)
aws ecr describe-images --repository-name example-platform-base --query 'imageDetails[].{digest: imageDigest, tags: imageTags}' --output table

## show all image tags
aws ecr describe-images --repository-name example-platform-base --output table --query "imageDetails[*].{ImageTag: imageTags[0], ImageDigest: @.imageDigest}"

```

