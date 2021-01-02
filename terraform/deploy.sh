#!/bin/bash
# configure
export environment=$1
export project="suparious"
if [ -z ${environment} ]; then
  export environment="dev"
fi
echo "Running for ${environment}."
export region="us-west-2"
export bucket="suparious-tf-states-${region}"
export s3_key="${project}/${environment}/${project}-${environment}.tfstat"
export tf_plan_file=".terraform/latest-plan"
export tf_override_vars=""
export tf_vars_file="${environment}.tfvars"

echo "Backend: s3://${bucket}/${s3_key}"
echo "Vars file: ${tf_vars_file}"

# init environment
tfenv install
tfenv use

set -e          # stop execution on failure
# check
INSTALLED=$(terraform version | head -n 1 | sed 's/Terraform v//')
DESIRED=$(cat .terraform-version)

if [ "$INSTALLED" = "$DESIRED" ]; then
    echo "Terraform version is matching"
else
    echo "ERROR: Terraform version mismatch detected"
    echo "ERROR: Found version: $INSTALLED, but expected version: $DESIRED."
    exit 1
fi

# init terraform
terraform init \
-backend-config="bucket=${bucket}" \
-backend-config="key=${s3_key}" \
-backend-config="region=${region}" \
-backend=true \
-force-copy \
-get=true \
-input=false

# plan
terraform plan \
-var-file="${tf_vars_file}" ${tf_override_vars} -out ${tf_plan_file}

# confirm
read -p "Do you want to APPLY these changes? " -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# apply
terraform apply --input=false ${tf_plan_file}

set +e          # return to default shell behavior (continue on failure)

exit 0
