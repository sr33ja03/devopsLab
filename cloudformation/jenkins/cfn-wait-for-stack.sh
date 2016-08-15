#!/usr/bin/env bash

stackname="$1"
region="$2"
status='UNKNOWN_IN_PROGRESS'

echo -n "Waiting $stackname to finish." >&2
while [[ $status =~ IN_PROGRESS$ ]]; do
    sleep 5
    status="$(aws cloudformation describe-stacks --stack-name $stackname --region $region --output text --query 'Stacks[0].StackStatus')"
    echo -n . >&2
done
echo ""
echo "Finished $stackname."

# if status is failed or we'd rolled back, assume bad things happened
if [[ $status =~ _FAILED$ ]] || [[ $status =~ ROLLBACK ]]; then
    exit 1
fi
exit 0