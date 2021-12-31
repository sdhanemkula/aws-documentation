# RDS

## General Guidelines
* Any manually created databases must utilize existing security group, vpc and subnet information.
* Utilize secrets manager to store all DB connection information! No connection values should be entered into either code or properties files. For example, the AWS Secrets Manager JDBC Library (https://github.com/aws/aws-secretsmanager-jdbc) automatically creates connections using credentials stored in AWS Secrets Manager thus removing the need to store credentials in properties files.
```
# mybatis-config.xml
# The driver utilizes the open source AWS secrets manager
	<environments default="development">
		<environment id="development">
			<transactionManager type="JDBC" />
			<dataSource type="POOLED">
        # Aws secrets manager JDBC driver wrapper
				<property name="driver" value="com.amazonaws.secretsmanager.sql.AWSSecretsManagerPostgreSQLDriver" />
        # URL of db instance to connect to
				<property name="url" value="jdbc-secretsmanager:postgresql://global-id-poc-database-1.c2l8tmejfrdn.us-east-1.rds.amazonaws.com:5432/sampleGlobalId" />
        # User Name is reference to secrets manager key name
				<property name="username" value="sam-poc-stack/dev/postgresql/globalId" />
  ...   
```

## Supportability
* Default RDS instance creation typically does NOT enable all query logs required. As a result for engines like PostgreSQL you must update the custom parameter group to enable!
```
# PostgreSQL - log_statement controls what is logged at the engine level (mod -> all update DDL statements)
log_statement: mod  (sample values: none, ddl, mod, all)
```


## Performance
* Applications MUST be cognizant of DB connections when using services like lambda. For example, connecting to RDS via infinitely scalable lambdas will cause throttling. As a result, RDS Proxy connection pooling should be investigated for scenarios like this.

## Costs
* Stopped RDS instances are automatically relaunched after 6 days! As a result, any developer test databases manually created must be either deleted or snapshotted and DELETED to avoid un-necessary costs. All databases created by the DBA team will be managed by that team.
