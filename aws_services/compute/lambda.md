# Lambda Functions

## General
* Understand [all limits on Lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/limits.html) processing when designing functions (THEY CAN NOT BE CHANGED!)
 - Startup time, Function timeout, total payload size (6MB sync, 256K async)

* Remember to cleanup any temp storage created/utilized by lambda functions!

* Utilize versioning/alias to simplify development workflow [see related article](https://docs.aws.amazon.com/lambda/latest/dg/versioning-aliases.html)
* Utilize ENV variables to configure lambdas do NOT hard code paths, bucket names, etc within the source code!

|Env variable name| Example |
| -- | -- |
|BUCKET_NAME	|us-east-1-product-raw|
|BUCKET_REGION|	us-east-1|
|SECRETS_KEY	|prod/aceapi/ingestor/api_key|

* Lazily load variables since execution contexts are re-used across invocations

* Consider [using using Layers for commonly utilized services/code](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html)

* No orchestration in code (e.g. NO Thread.sleep())!

* Remember that overall lambda "power" is determined by memory size. So in some scenarios CPU bound lambdas will execute faster with larger memory size due to less GC etc. Utilize lambda metrics to measure performance times to measure.

* Under the covers Lambda CPU usage is managed using slices of vCPU time. So for lambdas configured at 1792MB will get approx 100% of the vCPU. So the only way to reap the benefits from more CPU power above 1,792 MB is by writing your code to run in two threads simultaneously. [More information is here](https://dev.to/byrro/how-to-optimize-lambda-memory-and-cpu-4dj1)

* Understand impact of [using Reserve concurrency for your async lambdas](https://docs.aws.amazon.com/lambda/latest/dg/scaling.html).

* Utilize the "ReservedConcurrentExecutions" property to ensure the lambda executes when required, in addition to avoiding throttling downstream resources! For example if a downstream resource (e.g. DB, API) can only handle a certain amount of concurrent requests the lambda can ensure no throttling by using ReservedConcurrentExecutions.


## Costs
* Make sure to tune your memory size accordingly since this is the primary COST factor (assuming duration is constant)!
* Remember that sometimes increasing the memory [actually lowers costs!](https://medium.com/hackernoon/lower-your-aws-lambda-bill-by-increasing-memory-size-yep-e591ae499692)


## Naming Standards
* Utilize a consistent naming standards for lambdas using (product-application-component-env-function_name)

|example| comments |
| -- | -- |
|dev-IngestSingleRAResultDetails	|DEV environment lambda for ace product ingestor component|
|prod-IngestSingleRAResultDetails	|PROD environment Lambda for ace product ingestor component|


## Supportability
* Using a consistent naming standard for your lambdas makes finding the corresponding log group easier! (e.g /aws/lambda/mibcodeback-dev-ProcessMIBCodeBack)

## Performance
* Check lambda execution logs to determine actual execution time in addition to resource consumption
