# Lambda Functions (Java based)

## General
* Utilize the [AWS predefined handlers](https://docs.aws.amazon.com/lambda/latest/dg/java-handler-using-predefined-interfaces.html)

* POJOs passed as arguments to lambda functions must be mutable and have public get/set methods

* Minimize all dependent JARS as much as possible! Lambda startup loads all dependent JARS

* Java based lambdas require more memory (e.g. 128 MB is smallish) to execute within so configure accordingly. Check the lambda logs to see actual execution sizes.

* Upload JAR files to S3 location and have lambda reference code from that location (typically Java based lambdas are larger and can't be seen in AWS UI)

* Utilize Java based exceptions for relevant exception throwing (e.g. IllegalStateException if lambda is misconfigured)

* Java based lambdas require an 'uber' JAR including all dependencies. Utilize MVN plugins (e.g. Shade) when building the JAR and ensure NOT to include testing resources (test cases, frameworks, etc.)

## Supportability
* IF possible utilize the existing AWS logging plugins for logging statements. This ensures better format of error messages in addition to providing requestId into each log statement (this makes grouping lambda logs SO MUCH EASIER)

```yaml
## for example in Java based lambdas add this log4j2.xml in src/main/resources
<?xml version="1.0" encoding="UTF-8"?>
<Configuration packages="com.amazonaws.services.lambda.runtime.log4j2">
  <Appenders>
    <Lambda name="Lambda">
      <PatternLayout>
          <!--  This pattern makes our logging statements look like the same from cloud watch. -->
          <!--  It autoinserts the lambda requestId and also include the INFO/WARN in the line for easy querying -->
          <!--  INFO RequestId: abd-dasdfd-csdadf IngestSingleRAJsonHandler - the log message -->
          <pattern>%-5p RequestId: %X{AWSRequestId} %c{1} - %m%n</pattern>
      </PatternLayout>
    </Lambda>
  </Appenders>
  <Loggers>
    <Root level="info">
      <AppenderRef ref="Lambda" />
    </Root>
  </Loggers>
</Configuration>

## Then in code just do normal log4j calls
logger.info("dumping something out");

```

* You can write log messages to System.out.println (typically an anti-pattern in other tools/frameworks) and this does integrate with CloudWatch Insights but you will NOT have the RequestId added to each log message automatically thus limiting your ability to tie together all the log messages!
