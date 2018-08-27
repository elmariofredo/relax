# Relax
K8s simplified Gitops based CD

[![](https://images.microbadger.com/badges/image/elmariofredo/relax.svg)](https://microbadger.com/images/elmariofredo/relax "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/elmariofredo/relax.svg)](https://microbadger.com/images/elmariofredo/relax "Get your own version badge on microbadger.com")

> Simple GitOps deployment without [flux](https://github.com/weaveworks/flux/tree/master/site) overhead.

## How does it work

1. Create k8s Deployment ( see [./manifests](./manifests) )
2. Runs pod with simple loop in [./run.sh](./run.sh)
4. Bash script will clone git repo and run kubectl apply on selected namespace
