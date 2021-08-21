#!/bin/bash
find ./ -type f -iname "*.sh" -exec chmod +x {} \;

echo "Installing kubectl"
# install kubectl
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "Installing Kind"
# install kind
sudo curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

echo "Installing Docker"
# install docker using convenience script
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo groupadd docker
sudo usermod -aG docker ${USER}

echo "Installing Flux CD"
curl -s https://fluxcd.io/install.sh | sudo bash