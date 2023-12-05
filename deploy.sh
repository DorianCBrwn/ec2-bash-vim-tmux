#!/bin/bash -ex

STACK_NAME=${1:-devOps-env}
REGION=${2:-ap-northeast-1}
PROFILE=${3:-default}

deploy () {

  local CMD="aws cloudformation --region=${REGION} --profile=${PROFILE}"

  ${CMD} deploy \
  --stack-name ${STACK_NAME} \
  --template-file ./templates/ec2-ubuntu.yml \
  --parameter-overrides $(cat config/deploy.ini) \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM CAPABILITY_AUTO_EXPAND
}

deploy
