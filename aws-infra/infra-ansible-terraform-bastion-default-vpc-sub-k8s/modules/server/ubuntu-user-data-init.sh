#! /bin/bash
sudo apt-get update -y
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common  -y
sudo apt-get install docker.io -y
sudo wget -q -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo echo deb http://apt.kubernetes.io/ kubernetes-xenial main | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install kubelet=1.21.1-00 kubeadm=1.21.1-00 kubectl=1.21.1-00 -y
sudo apt-mark hold kubelet kubeadm kubectl
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 >> cluster_initialized.txt
sudo mkdir /root/.kube
sudo cp /etc/kubernetes/admin.conf /root/.kube/config
sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml -O
sudo kubectl apply -f calico.yaml

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
sudo sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
sudo systemctl restart kubelet.service

#kubeadm token create --print-join-command
