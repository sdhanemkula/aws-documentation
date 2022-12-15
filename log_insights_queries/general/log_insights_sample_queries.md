# Log Insights Sample Queries

Before running any query
* Make sure to set the logstream sources! (mule_ace_risk_production, mule_ace_product_api_production, mule_ace_submission_api_production)
* Make sure to set the timeframe!

## Sample ACE Mule log queries

```sql
-- show counts of any log messages with 'ERROR' in them by 15 minute intervals sorted by highest count first
filter @message like /ERROR/
| stats count(*) as exceptionCount by bin(15m)
| sort exceptionCount desc

-- select timestamp and message from logs having 'ERROR' in the message (sorted by earliest first)
fields @timestamp, @logStream, @message
| filter (@message like /ERROR/)
| sort @timestamp asc

-- find all ERROR messages and
-- parse apart the log messages into basic columns (my_date, my_time, status, request, etc.)
fields @timestamp, @logStream, @message
| parse @message "* * * * * *" as my_date, my_time, status, request, method, details
| filter (@message like /ERROR/)
| sort @timestamp asc

-- find any errors being thrown from specific method (accelerator)
fields @timestamp, @message
| parse @message "* * * * * *" as my_date, my_time, status, request, method, details
| filter (@message like /ERROR/) and (method like /acceleration.Accelerator/)
| sort @timestamp asc

-- find all risk ids that failed during run
-- parses apart the message using glob pattern,
parse @message "* * * * * *" as log_date, log_time, log_status, request, method_invoked, details
| fields @timestamp, substr(details, 26,36) as risk_id, @message
| filter (@message like /ERROR/) and (details like /Model response for risk/)
| sort @timestamp asc


--- find all logs with risk id in them
fields @timestamp, @message
| filter (@message like /6688052a-8f10-4617-be40-6c854dc8c1c3/)
```

## Tomcat based query samples

```sql
-- find all WARN messages in TPOS logs
fields @timestamp, @logStream, @message
| filter (@message like /WARN/)
| sort @timestamp asc

-- find all status code rows where 303 or 200
fields @logStream
| parse @message "* request=* requestbodylength=* requestduration=* statuscode=* *" as detail, request, bodylength, duration, status_code, rest_of_line
| filter status_code in [303, 200]

-- find all GET requests
fields @logStream
| parse @message "* request=* requestbodylength=* requestduration=* statuscode=* *" as detail, request, bodylength, duration, status_code, rest_of_line
| filter strcontains(request, "GET")

-- count all GET requests from tpos (summed by day)
parse @message "* request=* requestbodylength=* requestduration=* statuscode=* *" as detail, request, bodylength, duration, status_code, rest_of_line
| stats count(*) by bin(24h)
| filter strcontains(request, "GET")

-- show max PUT request duration across days
parse @message "* request=* requestbodylength=* requestduration=* statuscode=* *" as detail, request, bodylength, duration, status_code, rest_of_line
| stats max(duration) by bin(24h)
| filter strcontains(request, "PUT")

-- count all status codes from tpos (for given timeframe)
parse @message "* request=* requestbodylength=* requestduration=* statuscode=* *" as detail, request, bodylength, duration, status_code, rest_of_line
| stats count(*) by status_code
| filter ispresent(status_code)


-- Sample mule_pcs_mule_production using JSON fields in filter clause!
fields @timestamp, @logStream, @message
| filter level = 'ERROR' and file = 'DispatchingLogger.java'
| sort @timestamp asc
```
