# Jenkins on GKE

This spec will setup a Jenkins master with persistent volume on GKE. The master is exposed using an internal LB.

The `build-and-push-docker.sh` script will allow for easy deployment of a new Docker image. Replace the following values (current values provided):
- project (`vpn-poc-project`)
- zone (`us-east4-a`), 
- cluster name (`standard-cluster-1`).

## Access

Note that this cluster uses an internal load balancer. This means you'll need a jumpbox/bastion host/some form of hybrid connectivity to connect to the cluster. This can be changed by modifying the K8s service if this is an unnecessary requirement.

## Setup

### Cluster

1. Create GKE cluster
2. Deploy the spec
```bash
kubectl apply jenkins-kubernetes.yml
```
3. Run build-and-push-docker.sh.
```bash
./build-and-push-docker.sh
```
4. Wait for pods to go green

### Jenkins

Some information on setting up Jenkins can be found in [this Blazemeter article](https://www.blazemeter.com/blog/how-to-setup-scalable-jenkins-on-top-of-a-kubernetes-cluster) under the 'Jenkins Slaves Configuration
' heading.
1. Describe the Jenkins service so you can use the internal IP for configuring the Jenkins cluster
```bash
kubectl describe services jenkins
```
2. Log into the Jenkins master
3. Navigate to Jenkins configuration page
4. Scroll to the bottom and Add a Kubernetes Cloud option. You'll need to make use of the internal LB IP we grabbed earlier here.
