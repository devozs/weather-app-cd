# Weather App Deployment
#### A Continuous Deployment example project

### Key Features 🔑

- This deployment sample project is based on a [sample Java Maven project](https://github.com/devozs/weather-app)
- It's creating a [Kind](https://kind.sigs.k8s.io/) Cluster
- Deployment options 
  - Simple manual manifest deployment
  - [Flux](https://fluxcd.io/) continence deployment
- Using Flux Image Policy for ongoing docker image updates
- [Setup required tools script](https://github.com/devozs/weather-app-cd/blob/dev/setup-prerequisites.sh)
---
### Jenkins Pipeline 🌩️
- The Jenkins pipeline is executing the below deployment script. 
- Its for **testing and demonstration purposes only** and as such its deleting the existing cluster (if created).
- The pipeline is parameterized to support the below deployment options: Flux or manual manifest deployment.


### Deployment
    cd ~/[your-workspace]
    https://github.com/devozs/weather-app-cd.git

running the script ```./install-cluster.sh``` will create a Kind cluster.

There are two possible ways to deploy the [sample Java Maven project](https://github.com/devozs/weather-app)

#### Manual Deployment 🚪
    ./install-cluster.sh -t manual

#### FluxCD Deployment 🌩️
    ./install-cluster.sh -t flux -f your-github-account
For example `./install-cluster.sh -t flux -f devozs`


###### Make sure to have [GitHub PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)

###### For more information refer to the [Getting Started with Flux](https://fluxcd.io/docs/get-started/)

### Testing the deployment

#### Verify the flux pods are deployed successfully (Skip in case of using Manual Deployment)
```
kubectl get pods -n flux-system

NAME                                           READY   STATUS    RESTARTS   AGE
helm-controller-6dcbff747f-76xlv               1/1     Running   0          8m10s
image-automation-controller-75f784cfdc-29zcg   1/1     Running   0          8m10s
image-reflector-controller-67d6bdcb59-xb9m5    1/1     Running   0          8m10s
kustomize-controller-5bb9984cf9-7l7nk          1/1     Running   0          8m10s
notification-controller-7569f7c974-clccq       1/1     Running   0          8m10s
source-controller-5b976b8dd6-w6gjn             1/1     Running   0          8m10s
```
#### Verify the flux is able to identify the Docker images (Skip in case of using Manual Deployment)
```
flux get image policy -A

NAMESPACE       NAME            READY   MESSAGE                                                         LATEST IMAGE             
flux-system     weather-app     True    Latest image tag for 'devozs/weather-app' resolved to: 0.0.3    devozs/weather-app:0.0.3     

```

#### Verify the application pod is deployed successfully. for example:
```
kubectl get pod

NAME                         READY   STATUS    RESTARTS   AGE
weather-app-65ccb54c-z7cfv   1/1     Running   0          8m27s

```
#### Verify the application pod is running
```
    POD_NAME=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep weather-app)
    kubectl logs ${POD_NAME}

    2021/08/21 11:44:50.011 [INFO] [org.devozs.weather.WeatherApp] Task performed on: Sat Aug 21 11:44:50 GMT 2021, Thread's name: TIMER
    2021/08/21 11:44:50.011 [INFO] [org.devozs.weather.WeatherApp] Getting Weather...
    2021/08/21 11:44:51.722 [INFO] [org.devozs.weather.WeatherApp] Response Code: 200
```