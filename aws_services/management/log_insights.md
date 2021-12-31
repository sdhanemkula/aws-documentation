# Log Insights

## General
* Set your log groups to reasonable groupings (more groups != better)

* Tomcat logs have different structures than app logs! (localhost vs. app etc.)

* Log groups in UI messy after selecting 5 or so

* Download to CSV and easily manipulate using excel (limit to MB NOT GB of log data!)

* FILTERS apply to entire log group and will drop record if not match across logs. So for example, tomcat_localhost formats different than app log formats so may not see rows from both depending on query filter

* You can parse then filter on the parsed field!
```
parse @message "* * * * * *" as log_date, log_time, log_status, request, method_invoked, details
| fields @timestamp, substr(details, 26,36) as risk_id, @message
| filter (@message like /ERROR/) and (details like /Model response for risk/)
| sort @timestamp asc
```

* Do NOT create dashboards since they cost us extra $$$

* Currently limited to 4 concurrent queries per AWS account! This can be adjusted by contacting OPS to submit ticket to AWS support.

## Security
* Treat all log data as PII! Queries executed may return sensitive data (e.g. risk_ids, plan numbers, names, ssn)


## Cost
* Billed by size of data scan NOT length of query! ($0.005 per GB)
* Set your timeframe to reasonable time
* Limit queries to relevant log groups (don’t include every log group if not required)
