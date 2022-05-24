#!/bin/bash -x
apt update
apt install -y awscli

  
# artifacts:
#   - promotions-manager-ui: artifacts/latest/promotions-manager-ui.master.tar.gz
#   - promotions-manager-api: artifacts/latest/promotions-manager-api.master.tar.gz
#   - mongodb: artifacts/test-data/test-data-db.tar

ARTIFACTS_PATH="/tmp"
mkdir -p ${ARTIFACTS_PATH}
# aws s3 cp s3://${S3} $ARTIFACTS_PATH

aws s3 cp s3://${S3} ${ARTIFACTS_PATH} --recursive
