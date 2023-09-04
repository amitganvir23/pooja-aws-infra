#! /bin/bash
sudo apt-get update -y
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common  -y
sudo apt-get install docker.io -y
sudo wget -q -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo echo deb http://apt.kubernetes.io/ kubernetes-xenial main | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install kubectl=1.21.1-00 -y
sudo apt-mark hold  kubectl
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo date > /amit.txt