#!/bin/bash
set -e

printenv
echo "=== Begin validation phase ==="

echo "== Validating: ${CI_BRANCH} =="

# api
echo "= BEGIN api:${CI_BRANCH}"
curl google.ca
echo "= END api:${CI_BRANCH}"

echo "=== End validation phase ==="

set +e
