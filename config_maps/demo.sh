#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Create a config map"
run "cat $(relative configmap.yaml)"
run "kubectl --namespace=demos create -f $(relative configmap.yaml)"

desc "Create a pod which uses that config map"
run "cat $(relative pod.yaml)"
run "kubectl --namespace=demos create -f $(relative pod.yaml)"

while true; do
    run "kubectl --namespace=demos get pod configmaps-demo-pod"
    status=$(kubectl --namespace=demos get pod configmaps-demo-pod | tail -1 | awk '{print $3}')
    if [ "$status" == "Running" ]; then
        break
    fi
done
run "kubectl --namespace=demos exec --tty -i configmaps-demo-pod sh"
