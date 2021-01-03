#!/bin/sh
set -e
echo "=== Begin terraform phase ==="
cd terraform
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
ln -s ~/.tfenv/bin/* /usr/local/bin
which tfenv
cd ..
echo "=== End terraform phase ==="
export DOMAIN="suparious.com"
echo "=== Begin deployment phase ==="
cd /deploy && printenv
echo "== Deploying to: ${CI_BRANCH} =="

# web
echo "= BEGIN web:${CI_BRANCH}"
echo "Updating static web content"
echo "${CI_COMMIT_DESCRIPTION}-${CI_BRANCH}" > web/build.txt
cat web/build.txt

# apps
echo "= BEGIN apps:idlekeeper:${CI_BRANCH}"
cd apps && zip -r9 ../web/idlekeeper.zip idlekeeper/
cp idlekeeper/idlekeeper.run ../web/
mkdir ../web/idlekeeper
cp idlekeeper/web-install.sh ../web/idlekeeper/install.sh
cp idlekeeper/run.sh ../web/idlekeeper
cd ..
echo "= END apps:idlekeeper:${CI_BRANCH}"

# web deploy
case ${CI_BRANCH} in
  dev|stg)
    echo "Dploying ${CI_BRANCH} env web contents"
    aws s3 sync --delete --acl public-read web s3://${CI_BRANCH}.${DOMAIN}
    ;;
  prd)
    echo "Deploying Production env web contents"
    aws s3 sync --delete --acl public-read web s3://${DOMAIN}
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
