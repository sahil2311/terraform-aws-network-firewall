#!/usr/bin/env bash

action=$1
env=$2

if [ "$env" = "sandbox" ]; then
  AWS_REGION="us-east-1"
fi

accountid=$(aws sts get-caller-identity --query Account --output text)

echo "AWS_REGION = $AWS_REGION"
echo "Environment = $env"
echo "AWS_Account_ID = $accountid"

dynamodb_table=virima-terraform-backend-$env-lock
created_dynamodb_table=$(aws dynamodb list-tables --region $AWS_REGION | jq .TableNames[] | tr -d '"' | grep -w "$dynamodb_table")

bucket=virima-terraform-$env-$AWS_REGION-$accountid
created_bucket=$(aws s3 ls | grep -w "$bucket" | awk '{print $3}')

if [ "$created_bucket" != "$bucket" ]; then
  aws s3 mb s3://"$bucket" --region "$AWS_REGION"
  aws s3api put-public-access-block --bucket "$bucket" --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
  aws s3api put-bucket-versioning --bucket "$bucket" --versioning-configuration Status=Enabled
fi

if [ "$created_dynamodb_table" != "$dynamodb_table" ]; then
  aws dynamodb create-table --region $AWS_REGION --table-name "$dynamodb_table" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --deletion-protection-enabled > /dev/null 2>&1
fi

if [ "$3" = "" ]; then
  #service_apply="vpc backup s3 route53 sg database webapp integration-server management discovery processing-server cloudfront alb"
  service_apply="vpc backup route53 sg database webapp integration-server management discovery processing-server nlb alb"
else
  service_apply="$3"
fi

if [ "$action" = "plan" ]; then
  for service in $service_apply ; do
    echo "
    ###########################################################
    #                  Planning ""$service"" on ""$env""       #
    ###########################################################"
    echo ""
    cd "$service" || exit
    rm -rf .terraform*
    terraform init -backend-config="bucket=$bucket" -backend-config="dynamodb_table=$dynamodb_table" -backend-config="key=$service/$service-state.tfstate" -backend-config="encrypt=true" -backend-config="region=$AWS_REGION" > /dev/null 2>&1
    terraform "$action" -var environment="$env" -var aws_region="$AWS_REGION" -var remote_state_bucket="$bucket" -var remote_state_region="$AWS_REGION"
    sleep 1
    rm -rf .terraform*
    cd ..
  done
fi

if [ "$action" = "apply" ]; then
  for service in $service_apply; do
    echo "
    ###########################################################
    #                  Deploying ""$service"" on ""$env""      #
    ###########################################################"
    echo ""
    cd "$service" || exit
    #rm -rf .terraform*
    terraform init -backend-config="bucket=$bucket" -backend-config="dynamodb_table=$dynamodb_table" -backend-config="key=$service/$service-state.tfstate" -backend-config="encrypt=true" -backend-config="region=$AWS_REGION" > /dev/null 2>&1
    terraform "$action" -var environment="$env" -var aws_region="$AWS_REGION" -var remote_state_bucket="$bucket" -var remote_state_region="$AWS_REGION" --auto-approve
    sleep 1
    #rm -rf .terraform*
    cd ..
  done
fi

service_destroy=$(echo "$service_apply" | awk '{do printf "%s"(NF>1?FS:RS),$NF;while(--NF)}')

if [ "$action" = "destroy" ]; then
  for service in $service_destroy; do
    echo "
    ############################################################
    #                   Destroying ""$service""  on ""$env""    #
    ############################################################"
    echo ""
    cd "$service" || exit
    rm -rf .terraform*
    terraform init -backend-config="bucket=$bucket" -backend-config="dynamodb_table=$dynamodb_table" -backend-config="key=$service/$service-state.tfstate" -backend-config="encrypt=true" -backend-config="region=$AWS_REGION" > /dev/null 2>&1
    terraform "$action" -var environment="$env" -var aws_region="$AWS_REGION" -var remote_state_bucket="$bucket" -var remote_state_region="$AWS_REGION" --auto-approve
    sleep 1
    rm -rf .terraform*
    cd ..
  done
fi
