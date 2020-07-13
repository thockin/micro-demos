#!/bin/bash

. $(dirname ${BASH_SOURCE})/vars.sh

kubectl --context=$CTX1 delete namespace demo --wait=false
kubectl --context=$CTX2 delete namespace demo --wait=false
