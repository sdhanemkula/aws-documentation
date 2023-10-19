# Code Deploy

These are CodeDeploy related cli commands

```bash
## list all code deploy groups for given app (e.g. GWFRDev)
aws deploy list-deployment-groups --application-name GWFRDev

## list all code deployment groups (e.g. GWFRDev, deployment group -> GWDMPD1DEVElysiancogdisp)
aws deploy get-deployment-group --application-name GWFRDev --deployment-group-name GWDMPD1DEVElysiancogdisp

```

