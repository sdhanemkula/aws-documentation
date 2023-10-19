# EC2

```bash
## pull all instance names from w/in our account
aws ec2 describe-instances | jq -r '.Reservations[]|.Instances[]|[(.Tags[]?|select(.Key=="Name")|.Value), .InstanceId]|@csv' |sort

## pull only instances for a given customer name (name and version returned)
aws ec2 describe-instances --filters 'Name=tag:Name,Values=GWFRDEVE*' | jq -r '.Reservations[]|.Instances[]|[(.Tags[]?|select(.Key=="Name")|.Value), (.Tags[]?|select(.Key=="Version")|.Value), .InstanceId]|@csv' |sort

## return all instances flat w/JSON for tag values
aws ec2 describe-instances --filters 'Name=tag:Name,Values=GWFRDEVE*' | jq '.Reservations[].Instances[] | [.Tags, .InstanceId]'

## connect to specific instance using local ssm to a target instance (e.g. i-09bdc2d416dc251ff)
aws ssm start-session --target i-09bdc2d416dc251ff

## list all security groups for a given instance id (e.g. i-0501c82c14839ceca)
aws ec2 describe-instances --instance-id i-0501c82c14839ceca --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text

## list all security groups and ports for a given instanceId (i-0501c82c14839ceca)
aws ec2 describe-security-groups --group-ids $(aws ec2 describe-instances --instance-id i-0501c82c14839ceca --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text) --output text

## select security ports for a given security group id (sg-0372247d9a027bac8) 
## select .SecurityGroups.IpPermissions => create array of FromPort and all IpRanges.CidrIp property
aws ec2 describe-security-groups --group-ids sg-0372247d9a027bac8 | jq '.SecurityGroups[].IpPermissions[] | [.FromPort, .ToPort, .IpRanges[].CidrIp] | @csv'


## pull all subnets for given vpcId (output like "GWFRDevPrivateSubnet2","subnet-019e2c68c7971b36a","172.19.4.0/24")
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-0331f2f42b79e0db4" | jq '.Subnets[] | [(.Tags[]? | select(.Key=="Name") | .Value), .SubnetId, .CidrBlock ] | @csv'
```


## Descriptive commands w/JQ output manipulation
Sometimes I get confused with the jq syntax so these samples try and explain it out fully. Only keeping this here for my 30 day self.

```bash
## pull only instances for a given customer name (name and version returned)
aws ec2 describe-instances --filters 'Name=tag:Name,Values=GWDMPD1DEVE*' | jq -r '.Reservations[] | .Instances[] |
	[(.Tags[]? | select(.Key=="Name") | .Value), (.Tags[]? |select(.Key=="Version") | .Value), .InstanceId]|@csv'
## from Reservations.Instances section
##   pull InstanceId 
##   from Tags array (if present) select out the .Value for the matching .Key named 'Name'
    "Reservations": [
        {
            "Instances": [
                {
                    "InstanceId": "i-00fefdbdbac36e6ec",
                    "Tags": [
                        {
                            "Key": "Name",
                            "Value": "GWDMPD1DEVElysianCogdisp"
                        }]
                }
            ]            
		]}

## select security ports for a given security group id (sg-003214a037dfc496f) 
## "SecurityGroups": [
        {
            "IpPermissions": [
                {
                    "FromPort": 22,
                    "IpRanges": [
                        {
                            "CidrIp": "172.18.0.0/16"
                        }
                    ],
                    "ToPort": 22
		}
## select .SecurityGroups.IpPermissions => create array of FromPort, ToPort and all IpRanges.CidrIp property
aws ec2 describe-security-groups --group-ids sg-003214a037dfc496f | jq '.SecurityGroups[].IpPermissions[] | [.FromPort, .ToPort, .IpRanges[].CidrIp] | @csv'


## determine if a security group is being used by anything?
aws ec2 describe-network-interfaces --filters Name=group-id,Values=sg-09e239ea6f217b4bc

## determine if any security groups permit public IPRanges
aws ec2 describe-security-groups --query "SecurityGroups[].[GroupName, IpPermissions[?IpRanges[?CidrIp=='0.0.0.0/0' || CidrIp=='::/0']]]" 


```

```bash
# dump all EC2 instances and show Name, InstanceId, and PublicIpAddress
aws ec2 describe-instances | jq -r '.Reservations[]|.Instances[]|[(.Tags[]?|select(.Key=="Name")|.Value), .InstanceId, .PublicIpAddress]|@csv'|sort

## see specific instance IMDSv2 settings (need valid instance id)
aws ec2 describe-instances --instance-id i-01b1e140a84acca5a --query "Reservations[0].Instances[0].MetadataOptions"

## see all ebs volumes by (VolumeId, Encryption Status, EC2 Instance Id, Attachment State)
aws ec2 describe-volumes | jq -c '.Volumes[] | [.VolumeId, .Encrypted, .Attachments[].InstanceId, .Attachments[].State]'

## list all snapshots w/in account owned by us and show createVolumePermission
for snapshotId in `aws ec2 describe-snapshots --owner-ids self | jq .Snapshots[].SnapshotId -r`; do
   perms=$(aws ec2 describe-snapshot-attribute --snapshot-id $snapshotId --attribute createVolumePermission | jq -c '' | tr '\n' '\t')
   echo snapshotId '|' $perms
done
```
