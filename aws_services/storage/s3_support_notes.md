# S3 support Notes

The s3 support notes are mainly AWS cli commands to run to 'find' things in a bucket (usually specific to a risk id)
These example scripts assume you have jq installed locally! [jq is here](https://stedolan.github.io/jq/)

```
-- list the largest item in the bucket/prefix
aws s3api list-objects --bucket us-east-1-product-raw  \
	--prefix risk_assessments/modified_dt=2017-08-21/ | jq '[.Contents[]] | max_by(.Size)'

-- find the largest item in the bucket (risk_assessments)
aws s3api list-objects --bucket us-east-1-product-raw  \
	--prefix risk_assessments/ | jq '[.Contents[]] | max_by(.Size)'

-- list all file/sizes for a given bucket
aws s3api list-objects --bucket us-east-1-product-raw  \
	--prefix risk_assessments/modified_dt=2017-08-21/ | jq '.Contents[] | {key: .Key, size: .Size}'

-- find file in RAW RA_JSON folder by risk id
aws s3 ls s3://us-east-1-product-raw/ra_json --recursive |grep 019a069d-814e-4cf6-99ea-a706d0ffd2f0

-- find file in RAW risk_assessments folder by risk id
aws s3 ls s3://us-east-1-product-raw/risk_assessments --recursive |grep 00cfdf07-5175-463e-a7a3-478c2d432cba

-- download all keys to local file (then find risk-ids in key file)
aws s3 ls s3://us-east-1-product-raw/ra_json --recursive > ra_Json.txt
grep 019a069d-814e-4cf6-99ea-a706d0ffd2f0 ra_Json.txt

```
