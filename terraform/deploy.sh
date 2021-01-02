#!/bin/bash
# configure
export environment="dev"
export project="suparious"
export s3_key="${project}/${environment}/${project}-${environment}.tfstat"
export project_dir="."
export tf_plan_file=".terraform/latest-plan"
export ecs_image_tag="latest"
export lambda_tag="latest"
export lambda_tag2="latest"
export lambda_layer_tag="latest"
export lambda_layer_tag2="latest"
export bucket="terraform-states-us-west-2"
export region="us-west-2"
export tf_override_vars="-var ecs_image_tag=${ecs_image_tag} -var lambda_tag=${lambda_tag} -var lambda_tag2=${lambda_tag2} -var lambda_layer_tag=${lambda_layer_tag} -var lambda_layer_tag2=${lambda_layer_tag2}"
export tf_vars_file="${environment}.tfvars"
export TF_LOG="INFO"

# clean
sed '/^source_profile/d' ${HOME}/.aws/config > ${HOME}/.aws/config
#rm -rf .terraform   # comment this out to make the init faster, at the risk of having stale modules

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

# init
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