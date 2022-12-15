# VPC Sample log insights queries

These are ECR related log insights queries

```bash
### log insights query (find all traffic for given destination)
fields srcAddr, srcPort, dstAddr, dstPort, end, logStatus, action, @message
| filter dstAddr = "172.19.57.28" and logStatus in ["OK"]
| sort @timestamp desc
| limit 200


### show how much traffic being sent to different ports for given interface id
fields @timestamp, @message
 | stats count(*) as records by dstPort, srcAddr, dstAddr as Destination
 | filter interfaceId="eni-0eedcfec11cf0cf47"
 | filter dstPort="80" or dstPort="443" or dstPort="22" or dstPort="25"
 | sort HitCount desc
 | limit 10
 

## show me everything being rejected w/in given VPC IPs (in or out)
fields @timestamp, srcAddr, dstAddr, action
| filter action = 'REJECT' and (srcAddr like '172.19' or dstAddr like '172.19')
| sort @timestamp desc
| limit 500
 

## show me count of traffic being rejected w/in given VPC IPs (by destination Address)
fields srcAddr, dstAddr, action
| filter action = 'REJECT' and dstAddr like '172.19'
| stats count(*) by dstAddr


## show summary of all traffic accepted/rejected for given destination range of IPs
fields srcAddr, dstAddr, action
| filter dstAddr like '172.19'
| stats count(*) by action


## show summary of all traffic accepted/rejected for given source range of IPs
fields srcAddr, dstAddr, action
| filter srcAddr like '172.19'
| stats count(*) by action

```

