# Aurora Vs. RDS
This page summarizes main differences between choosing aurora vs RDS

| Item | Aurora | RDS |
| -- | -- | -- |
|SQL|Proprietary, compliant with MySQL 5.6 and PostgreSQL 9.6|MySQL, PostgreSQL|
|Engine|InnoDB only(no MyISAM engine)||
|Performance|**5x faster throughput over MySQL RDS**, can be slower in flows with secondary indexes||
|Cost|**~20% more than MySQL RDS**, per hour|Per hour, free tier|
|Disk/Storage||Two SSD options: high performance OLTP vs. standard
|Storage Auto scaling|10GB min/increments **No upfront provision**|Provision up front|
|Replication|Up to 15 instant replicas, **Failover automatic no data loss**|Limited to 5 replicas (slower than Aurora),manual may have minute data loss|
|Backup|**Automatic, incremental, continuous**|Require scheduling, may slow IO during|
|Availability|**Automatic, recovery within minutes**|Manual, recovery typically longer|
