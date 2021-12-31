# Secrets Manager

## General
* Do NOT store application 'secrets' (e.g. user ids, passwords, etc.) in source code or properties files!
* Most SECRETS should be stored in the central AWS 'secrets' account. Each development account will be granted permissions to secrets within this account based on secret names.

## Naming Standards
* Utilize a consistent naming standard when creating secret names

| Example | Description |
| -- | -- |
| prd/aceapi/ingestor/api_key  | PRD account ACE API Key (e.g. BASIC auth info) |
| dev/cassandra/connection| DEV Cassandra connection information (e.g. user name, password, IPAddresses, etc.)  |
