#!/bin/bash

set -eoi
: AWS_REGION

if [ -z "${AWS_PROFILE:-}" ]; then
  echo "Profile not set"
	exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"

concourse_password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c20)
postgress_password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c20)


cat >$SCRIPT_DIR/vars.yml<<EOF
concourse_password: $concourse_password
postgress_password: $postgress_password
EOF

if [ -f "$SCRIPT_DIR/values.json" ]; then
  cd "$SCRIPT_DIR"
  packer build -var-file=values.json \
   -var "aws_access_key=$(aws configure get aws_access_key_id)" \
   -var "aws_secret_key=$(aws configure get aws_secret_access_key)" \
   -var "concourse_password=$concourse_password" \
   -var "postgress_password=$postgress_password" \
   -var "aws_region=$AWS_REGION" \
   bootstrap_concourse.json
else
  echo "
 Note:

 Before you can build this Concourse AMI,
 you must create secrets.json
"
fi