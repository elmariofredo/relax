# Relax
K8s simplified Gitops based CD

> Simple GitOps deployment without [flux](https://github.com/weaveworks/flux/tree/master/site) overhead.

## How does it work

1. Create k8s [Cron Job](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) ( see [./manifests](./manifests) )
2. Cron Job run every e.g. 5 minutes
3. Executes simple bash script with specified git and namespace ( see [./run.sh](./run.sh) ) 
4. Bash script will ensure namespace is present, then shallow clone git repo and run kubectl apply on selected namespace
