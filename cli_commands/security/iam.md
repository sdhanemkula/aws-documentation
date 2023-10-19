# IAM

These are IAM related cli commands

```bash
## get all iam users in our account
aws iam list-users | jq '.Users[].UserName'

## list all users tags
aws iam list-user-tags --user-name myUserName

## who am I?
aws sts get-caller-identity


## list all users/tags w/in account
for userName in `aws iam list-users | jq .Users[].UserName -r`; do
   tags=$(aws iam list-user-tags --user-name $userName | jq -c '' | tr '\n' '\t')
   echo $userName '|' $tags
done
```


