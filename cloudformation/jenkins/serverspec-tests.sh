#!/usr/bin/env bash
set -e

stackname="$1"
region="$2"
envtype="$3"

#gem install rspec aws-sdk

pushd serverspec
WebAppStack="$(aws cloudformation describe-stacks --stack-name $stackname --region $region --output text --query "Stacks[0].Outputs[?OutputKey=='WebAppStack$envtype'].OutputValue")"
export webapp_security_group="$(aws cloudformation describe-stack-resources --stack-name $WebAppStack --region $region --query StackResources[?LogicalResourceId==\`WebAppSG\`].PhysicalResourceId --output text)"
export webapp_region=$region
/usr/local/bin/rspec
popd
