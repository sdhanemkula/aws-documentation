# VPC Flow Logs

This page summarizes relevant information on usage of vpc flow logs.


```bash
# sample flow log message string
2 XXXXXXXXXXXX eni-0c7632f102236ee56 172.19.55.86 52.94.228.178 20666 443 6 26 5813 1697651834 1697651835 ACCEPT OK

```

| Version | Account | ENI | Src IP | Dest IP| Src Port | Dest port | Bytes | Start Time | End Time | Condition | Status |
| -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
| 2 | XXXXXXXXXXXX | eni-0c7632f102236ee56 | 172.19.55.86 | 52.94.228.178 | 20666 | 443 | 5813 | 1697651834  |1697651835 | ACCEPT | OK |


  