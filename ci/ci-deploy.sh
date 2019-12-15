#!/bin/sh
set -e

echo "=== Begin deployment phase ==="
cd /deploy && printenv
echo "== Deploying to: ${CI_BRANCH} =="

# web
echo "= BEGIN web:${CI_BRANCH}"
echo "Updating static web content"
#aws s3 mb s3://${CI_BRANCH}.minerhub.co
echo "${CI_COMMIT_DESCRIPTION}-${CI_BRANCH}" > web/build.txt
cat web/build.txt
case ${CI_BRANCH} in
  dev|stg)
    echo "Development env scripts"
    #aws s3 cp --acl public-read web/index.html s3://${CI_BRANCH}.minerhub.co
    #aws s3 cp --acl public-read web/build.txt s3://${CI_BRANCH}.minerhub.co
    #aws s3 website s3://${CI_BRANCH}.minerhub.co --index-document index.html
    aws s3 sync --delete --acl public-read web s3://${CI_BRANCH}.minerhub.co
    ;;
  prd)
    echo "Production deployment scripts"
    #aws s3 cp --acl public-read web/index.html s3://minerhub.co
    #aws s3 cp --acl public-read web/build.txt s3://minerhub.co
    #aws s3 website s3://minerhub.co --index-document index.html
    aws s3 sync --delete --acl public-read web s3://minerhub.co
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
