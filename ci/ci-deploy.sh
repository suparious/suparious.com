#!/bin/sh
set -e
export DOMAIN="suparious.com"
echo "=== Begin deployment phase ==="
cd /deploy && printenv
echo "== Deploying to: ${CI_BRANCH} =="

# web
echo "= BEGIN web:${CI_BRANCH}"
echo "Updating static web content"
#aws s3 mb s3://${CI_BRANCH}.${DOMAIN} - no, use terraform
echo "${CI_COMMIT_DESCRIPTION}-${CI_BRANCH}" > web/build.txt
cat web/build.txt
case ${CI_BRANCH} in
  dev|stg)
    echo "Development env scripts"
    aws s3 cp --acl public-read web/error.html s3://${CI_BRANCH}.${DOMAIN}
    aws s3 cp --acl public-read web/index.html s3://${CI_BRANCH}.${DOMAIN}
    aws s3 cp --acl public-read web/build.txt s3://${CI_BRANCH}.${DOMAIN}
    aws s3 website s3://${CI_BRANCH}.${DOMAIN} --index-document index.html
    aws s3 website s3://${CI_BRANCH}.${DOMAIN} --error-document error.html
    #aws s3 sync --delete --acl public-read web s3://${CI_BRANCH}.${DOMAIN}
    ;;
  prd)
    echo "Production deployment scripts"
    aws s3 cp --acl public-read web/error.html s3://${DOMAIN}
    aws s3 cp --acl public-read web/index.html s3://${DOMAIN}
    aws s3 cp --acl public-read web/build.txt s3://${DOMAIN}
    aws s3 website s3://${DOMAIN} --index-document index.html
    aws s3 website s3://${DOMAIN} --error-document error.html
    #aws s3 sync --delete --acl public-read web s3://${DOMAIN}
    ;;
esac
echo "= END web:${CI_BRANCH}"

# api
echo "= BEGIN api:${CI_BRANCH}"
case ${CI_BRANCH} in
  dev)
    aws s3 ls
    echo "Development env scripts"
    ;;
  stg)
    echo "Staging env scripts"
    aws s3 ls
    ;;
  prd)
    echo "Yeah you wish"
    aws s3 ls
    ;;
esac
echo "= END api:${CI_BRANCH}"

echo "=== End deployment phase ==="

set +e
