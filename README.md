# Weather App Deployment
#### A Continuous Deployment example project

### Key Features 🔑

- This deployment sample project is based on a [sample Java Maven project](https://github.com/devozs/weather-app)
- It's creating a [Kind](https://kind.sigs.k8s.io/) Cluster
- Deployment options 
  - Simple manual manifest deployment
  - [Flux](https://fluxcd.io/) continence deployment
- Using Flux Image Policy for ongoing docker image updates 
---

### Deployment
The script ```./install-cluster.sh``` creating Kind cluster.

There are two possible ways to deploy the [sample Java Maven project](https://github.com/devozs/weather-app)

#### Manual Deployment 🚪
    ./install-cluster.sh -t manual

#### FluxCD Deployment 🌩️
    ./install-cluster.sh -t flux -f your-github-account
For example `./install-cluster.sh -t flux -f devozs`


###### Make sure to have [GitHub PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)

###### For more information refer to the [Getting Started with Flux](https://fluxcd.io/docs/get-started/)
