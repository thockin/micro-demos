#!/bin/bash

. $(dirname ${BASH_SOURCE})/udemo.sh
. $(dirname ${BASH_SOURCE})/vars.sh

PRJ=thockin-dev-2
CTX1="demo1"
CTX2="demo2"

GCLOUD="gcloud --project=$PRJ"
K1="kubectl --context=$CTX1"
K2="kubectl --context=$CTX2"

desc "look ma, clusters!"
run "$GCLOUD container clusters list"
desc "they are registered in an environ"
run "$GCLOUD container hub memberships list"

desc "but they are empty"
run "$K1 get ns"
run "$K2 get ns"

desc "make namespaces for the demo"
run "$K1 create ns demo"
run "$K2 create ns demo"

desc "let's deploy a service"
run "cat $(relative deploy1.yaml)"
run "$K1 -n demo apply -f $(relative deploy1.yaml)"
run "$K1 -n demo expose deploy msg --port=80 --target-port=9376"

desc "prove it"
run "$K1 -n demo run -ti --rm --restart=Never --image=busybox shell-$RANDOM -- wget -qO- msg"

desc "now for some fun"
run "$K1 get crd"
desc "export the service and import it into demo2"
run "cat $(relative export.yaml)"
run "$K1 -n demo apply -f $(relative export.yaml)"

desc "see - it got imported"
run "$K1 -n demo get importedservice"
desc "even in the other cluster"
run "$K2 -n demo get importedservice"
desc "here's the WOW"
run "$K2 -n demo run -ti --rm --restart=Never --image=busybox shell-$RANDOM -- wget -qO- 10.255.255.254"
desc "even better"
run "$K2 -n demo run -ti --rm --restart=Never --image=busybox shell-$RANDOM -- wget -qO- msg.demo.svc.supercluster.local"

desc "let's go even farther"
run "cat $(relative deploy2.yaml)"
run "$K2 -n demo apply -f $(relative deploy2.yaml)"
run "$K2 -n demo expose deploy msg --port=80 --target-port=9376"
run "$K2 -n demo apply -f $(relative export.yaml)"

desc "and the coup de grace"
run "$K2 -n demo run -ti --rm --restart=Never --image=busybox shell-$RANDOM -- sh -c \"for i in \\\$(seq 1 10); do wget -qO- msg.demo.svc.supercluster.local; done\""
