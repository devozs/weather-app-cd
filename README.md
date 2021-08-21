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
    POD_NAME=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep weather-app)
    kubectl logs ${POD_NAME}
Verify that the pod produces the right logs that indicates of successful REST API weather call. for example:
```
    2021/08/21 11:44:50.011 [INFO] [org.devozs.weather.WeatherApp] Task performed on: Sat Aug 21 11:44:50 GMT 2021, Thread's name: TIMER
    2021/08/21 11:44:50.011 [INFO] [org.devozs.weather.WeatherApp] Getting Weather...
    2021/08/21 11:44:51.722 [INFO] [org.devozs.weather.WeatherApp] Response Code: 200
```