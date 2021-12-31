# RDS - PostgreSQL

This page provides any learnings using RDS PostgreSQL instances

## General Guidelines
* TODO:

## Porting from Oracle to PostgreSQL
* There are numerous data type differences between Oracle and PostgreSQL. Please work with the DBA team if attempting to port an application from Oracle!
* Be mindful of encrypted DB columns! A column encrypted by oracle is NOT readable in postgreSQL. This requires un-encryption during the data migration steps.
* Object names casing is different between the two engines! Oracle => uppercase, PostgreSQL => lower case
* Example myBatis porting from Oracle to PostgreSQL proved easy porting with most changes restricted to dates and time type mismatches between the engines.

## Supportability
* Default RDS instance creation typically does NOT enable all query logs required. As a result for engines like PostgreSQL you must update the custom parameter group to enable!
```
# PostgreSQL - log_statement controls what is logged at the engine level (QA -> all update DDL statements)
log_statement: mod  (sample values: none, ddl, mod, all)
```

## Performance
* TODO:
