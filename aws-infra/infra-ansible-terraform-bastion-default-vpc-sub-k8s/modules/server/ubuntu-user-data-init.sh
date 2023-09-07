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
##- fixing core dns issue
sudo echo 'Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
##
sudo sysctl --system
sudo sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
sudo systemctl daemon-reload
sudo systemctl restart kubelet.service

### checking status before executing core dns patch
state=$(sudo kubectl get nodes |grep master|awk '{print $2}')
while [[ "$state" != "Ready" ]]
do
  state=$(sudo kubectl get nodes |grep master|awk '{print $2}')
  echo Current state $state
  sleep 5
done

sudo touch /k8sdone
#sudo systemctl restart kubelet.service
#kubeadm token create --print-join-command

# To resolve DNS issue for service_name.namespace.svc.cluster.local
#cat <<EOF | sudo tee dns-patch.sh
#!/usr/bin/env bash
#set -e
#if [[ $# == 0 ]]; then
#  echo "Usage: $0 DEPLOYMENT [kubectl options]" >&2
#  echo "" >&2
#  echo "This script recreates the pods managed by the specified deployment." >&2
#  exit 1
#fi
#function _kubectl() {
#  kubectl $@ $kubectl_options
#}
#deployment="$1"
#updated_at=$(date +%s)
#kubectl_options="${@:2}"
#_kubectl patch deployment "$deployment" \
#  -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"force-update.zlab.co.jp/updated-at\":\"$updated_at\"}}}}}"
#EOF

## refer to https://www.dbi-services.com/blog/kubernetes-dns-resolution-using-coredns-force-update-deployment/
##sudo wget https://raw.githubusercontent.com/zlabjp/kubernetes-scripts/master/force-update-deployment
##sudo chmod a+x force-update-deployment

#kubectl patch deployment coredns -n kube-system -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"force-update/updated-at\":\"$(date +%s)\"}}}}}"

### checking status before executing core dns patch
#state=$(sudo kubectl get nodes |grep master|awk '{print $2}')
#while [[ "$state" != "Ready" ]]
#do
#  state=$(sudo kubectl get nodes |grep master|awk '{print $2}')
#  echo Current state $state
#  sleep 5
#done
#sudo ./force-update-deployment coredns -n kube-system
#
