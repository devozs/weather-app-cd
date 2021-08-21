#!/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)

FLUX_GITHUB_OWNER=""
DEPLOYMENT_TYPE=""

command -v kubectl >/dev/null 2>&1 || {
  echo >&2 "${red}I require kubectl but it's not installed.  Aborting."
  exit 1
}
command -v kind >/dev/null 2>&1 || {
  echo >&2 "${red}I require kind but it's not installed.  Aborting."
  exit 1
}
command -v docker >/dev/null 2>&1 || {
  echo >&2 "${red}I require docker but it's not installed.  Aborting."
  exit 1
}


Help() {
  echo "$(basename "$0") deploying a kind cluster with optional docker image build"
  echo "1) TBD"
  echo
  echo "Examples:"
  echo " - './install-cluster.sh' will create Kind cluster and apply the k8s manifest"
  echo " - './install-cluster.sh -b will also build the Docker images as well as create the cluster'"
  echo
  echo "Usage: $(basename "$0") [-h] [-b]"
  echo "Options:"
  echo "-h        Print this Help."
  echo "-f        GITHUB flux repository owner"
  echo
}

options=':f:t:h'
while getopts $options option; do
  case "$option" in
  f) FLUX_GITHUB_OWNER=$OPTARG ;;
  t) DEPLOYMENT_TYPE=$OPTARG ;;
  h)
    Help
    exit
    ;;
  \?)
    echo "Unknown option: -$OPTARG" >&2
    exit 1
    ;;
  :)
    echo "Missing option argument for -$OPTARG" >&2
    exit 1
    ;;
  *)
    echo "Unimplemented option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done

shift $((OPTIND - 1))

if (($# > 0)); then
  echo "No arguments are allowed, see below help"
  Help
  exit
fi

if [[ "${DEPLOYMENT_TYPE}" == "flux" ]]; then
  echo "Using Flux deployment"
  command -v flux >/dev/null 2>&1 || {
    echo >&2 "${red}I require fluxcd but it's not installed.  Aborting."
    exit 1
  }
  if [[ -z "${GITHUB_TOKEN}" ]]; then
    echo "GITHUB_TOKEN environment variable not found (required for flux cd)"
    exit 1
  fi

  if [[ -z "${FLUX_GITHUB_OWNER}" ]]; then
    echo "Flux GITHUB owner is missing"
    exit 1
  fi
elif [[ "${DEPLOYMENT_TYPE}" == "manual" ]]; then
  echo "Using manual manifest deployment"
else
  echo "Missing deployment type, please use either '-t flux' or '-t manual'"
  exit 1
fi

KIND_CLUSTER_NAME="kind"
EXISTING_CLUSTERS=$(kind get clusters)

if [[ ${EXISTING_CLUSTERS} == *"${KIND_CLUSTER_NAME}"* ]]; then
  echo "${red}Kind cluster named ${blue}${KIND_CLUSTER_NAME} ${red}already exists."
  echo "${red}You will have to delete it first using: ${yellow}kind delete cluster --name ${KIND_CLUSTER_NAME}${red} before installing it again"
  exit
else
  echo "${blue}Kind cluster named ${yellow}${KIND_CLUSTER_NAME} ${blue}not yet exists, starting installation..."
fi

cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "0.0.0.0"
  apiServerPort: 6443
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF


if [[ "${DEPLOYMENT_TYPE}" == "flux" ]]; then
  # # # # # # # # # # # # # # # #
  # Flux deployment             #
  # # # # # # # # # # # # # # # #
  flux bootstrap github \
    --owner=devozs \
    --repository=ci-cd-k8s-example \
    --branch=dev \
    --path=./clusters/dev \
    --personal \
    --token-auth \
    --components-extra=image-reflector-controller,image-automation-controller
elif [[ "${DEPLOYMENT_TYPE}" == "manual" ]]; then
  # # # # # # # # # # # # # # # #
  # Manual deployment           #
  # # # # # # # # # # # # # # # #

  # echo "${blue}Loading images into kind${reset}"

  echo "${blue}Applying kubernetes manifests${reset}"
  kubectl apply -f clusters/dev/backend/weather-app.yaml
  kubectl rollout status deployment/weather-app

else
  echo "Missing deployment type, please use either '-t flux' or '-t manual'"
  exit 1
fi




echo "${blue}Deployment finished${reset}"