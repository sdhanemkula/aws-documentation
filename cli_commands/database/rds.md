# RDS

These are RDS related cli commands

```bash
## describe cluster
aws rds describe-clusters | jq '.DBClusters[] | [.Engine, .MasterUsername, .DBClusterIdentifier]'
aws rds describe-db-clusters | jq '.DBClusters[] | [.Engine, .MasterUsername, .DBClusterIdentifier] | @csv'

## describe instances 
aws rds describe-db-instances
aws rds describe-db-instances | jq '.DBInstances[] | [.Engine, .MasterUsername, .StorageType, .DBInstanceArn] | @csv'

```

