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
2. Log into Jenkins and navigate to “Manage Jenkins -> Configure System -> Cloud -> Kubernetes” and fill in the ‘Kubernetes URL’ and ‘Jenkins URL’ appropriately, by using the values from the previous setp:
> This is an example image taken from the Blazemeter article
![Kubernetes Cloud Config](https://cdn2.hubspot.net/hubfs/208250/Blog_Images/scalablejenkins13.png)
3. Setup the 'Kubernetes Pod Template' section, specifically:

   - Name - used as a prefix for unique slave names. Takes any string value.
   - Labels - Selector labels for Jenkins jobs. May leave blank.
   - Usage - Determines how often slaves will be used. Set this to 'Use this node as much as possible' to have jobs default to Docker slaves.
   - Docker image - Docker image name that will be used for Jenkins slaves. Recommend using [the default image](https://hub.docker.com/r/jenkinsci/jnlp-slave/) for now.
> This is an example image taken from the Blazemeter article
![Kubernetes Pod Template](https://cdn2.hubspot.net/hubfs/208250/Blog_Images/scalablejenkins14.png)
4. Create a new Job and start a build. The containers will take a little bit of time to start the first time around.
