# SSM

Sample SSM cli commands

```bash
## pull all params out of account (and only show name)
aws ssm describe-parameters | jq '.Parameters[].Name'

## pull all params out of account (name and type)
aws ssm describe-parameters | jq '.Parameters[] | [.Name, .Type] | @csv'

## show all SSM parameters w/in account
aws ssm get-parameters-by-path --path '/' | jq '.Parameters[] | [.Name, .LastModifiedDate] | @csv'
```


## AWS Session Manager Plugin
The AWS Session manager plugin is useful when running locally and want to CLI directly into an instance (no need to copy keys etc.)

[This article provides good info on how to use the tool and setup etc.](https://www.tripwire.com/state-of-security/aws-session-manager-enhanced-ssh-scp-capability)

### Pre Reqs

To check if ec2 has correct ssm-agent installed on it refer to these links
# https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent-get-version.html
# https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent-status-and-restart.html

```bash
## must be sudo
sudo -s

## check if agent running
sudo systemctl status amazon-ssm-agent

## check agent version
yum info amazon-ssm-agent
```

### install instructions for plugin into CLI
[Following these steps outlined here](https://www.tripwire.com/state-of-security/aws-session-manager-enhanced-ssh-scp-capability)

NOTE: wasn't able to do scp type commands using the plugin when testing locally. I'm sure it'll work we just didn't have our perms setup correctly.

```bash
## install aws cli
brew install awscli

## verify version
aws --version

## install session manager plugin (for AWS CLI)
## https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-macos
brew install --cask session-manager-plugin

## check installation is correct
## https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-verify
session-manager-plugin

## connect to specific instance using local ssm to a target instance (i-09bdc2d416dc251ff)
aws ssm start-session --target i-09bdc2d416dc251ff
```