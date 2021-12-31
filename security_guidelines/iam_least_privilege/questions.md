# IAM Least Privilege 
This page summarizes various questions to ask related to the Identity and Access Management pillar.

## Questions

* **What permissions does my 'dev role' require?**
    * **Service level**: CRUD (dev create queue, topic, table, etc.)
    * **Resource level**: CRUD (dev put item/read item from queue, topic, etc.)

<br/>

* **What permissions does my 'service role' require?**
    * **Item level**: read only? Delete item?

<br/>

* **What fine gained permissions can I add to my service to further restrict access?**
    * Resource instance level (e.g. limit access to only QueueA)
    * Resource endpoint (e.g. limit access of API gateway endpoint A only POST for X group)
    * Resource S3 bucket (e.g. limit clarifi-raw to only GET from bus/clarifi users)
