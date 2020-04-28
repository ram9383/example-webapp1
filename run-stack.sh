#!/bin/bash
set -e
set -x

STACK_NAME=$1
ALB_LISTENER_ARN=$2

if ! aws cloudformation describe-stacks --region us-east-2 --stack-name $STACK_NAME 2>&1 > /dev/null
then
	finished_check=stack-create-complete
else
	finished_check=stack-update-complete
fi

aws cloudformation deploy \
    --region us-east-2 \
    --stack-name $STACK_NAME \
    --template-body service.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
    "DockerImage=023586244730.dkr.ecr.us-east-2.amazonaws.com/example-webapp:$(git rev-parse HEAD)" \
	"Subnet=subnet-4c8a7527" \
    "VPC=vpc-d28a5db9" \
    "Cluster=default" \
    "Listener=$ALB_LISTENER_ARN"