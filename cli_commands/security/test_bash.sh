#!/bin/bash

for userName in `aws iam list-users | jq .Users[].UserName -r`; do
   tags=$(aws iam list-user-tags --user-name $userName | jq '' | tr '\n' '\t')
   echo $userName '|' $tags
done
