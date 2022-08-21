#!/bin/bash
set -e
export DOMAIN="suparious.com"
printenv
cd $GOPATH
echo "=== Begin test phase ==="
echo "== Testing for: ${CI_BRANCH} =="

# web
echo "= BEGIN web:${CI_BRANCH}"
set +e
case ${CI_BRANCH} in
  stg|dev)
  curl ${CI_BRANCH}.${DOMAIN}
  EXT=$?
  if [ $EXT -ne 0 ]; then
    echo "something fucked-up with: ${CI_BRANCH}.${DOMAIN}"
    exit $EXT
  fi
  ;;
  prd)
  curl ${DOMAIN}
  EXT=$?
  if [ $EXT -ne 0 ]; then
    echo "something fucked-up with: ${DOMAIN}"
    set -e
    exit $EXT
  fi
  ;;
esac
set -e
echo "= END web:${CI_BRANCH}"

# api
echo "= BEGIN api:${CI_BRANCH}"
cd $GOPATH/src
for app in $(ls -1 | grep -Ev 'github|golang'); do
  echo "$app: building deps"
  go get github.com/gorilla/mux
	go get github.com/jinzhu/gorm
	go get github.com/rs/cors
	go get golang.org/x/crypto/bcrypt
	go get github.com/joho/godotenv
	go get github.com/lib/pq
	go get github.com/dgrijalva/jwt-go
	go get -u golang.org/x/lint/golint
	go get -u github.com/lib/pq
  echo "$app: golint linting"
  golint -set_exit_status $app
  echo "$app: govet linting"
  #go vet -c=3 $app/...
  echo "$app: compiling"
  #make install $app
  #ls -al bin/$app*
done
echo "= END api:${CI_BRANCH}"
echo "=== End test phase ==="

set +e
