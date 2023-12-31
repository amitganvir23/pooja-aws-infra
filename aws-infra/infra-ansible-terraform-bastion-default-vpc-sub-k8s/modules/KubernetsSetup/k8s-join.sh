#! /bin/bash
### its only for Ubuntu
export user=ubuntu
export env=$env
export key=$key
echo Environment is $env

## Master
#master_instance_id=$(aws ec2 describe-instances --filters "Name=tag:Role,Values=${env}-server" --output text --query 'Reservations[*].Instances[*].InstanceId')
#export master_instance_ip=$(aws ec2 describe-instances --instance-ids $master_instance_id \
#    --query 'Reservations[*].Instances[*].PublicIpAddress' \
#    --output text)
export master_instance_ip=$server_ip

echo Server Server master_instance_id $master_instance_id $master_instance_ip
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "while [ ! -f /k8sdone ];do echo -e Waiting Master Node for k8s-deployment-init...;sleep 5; done"
export k8s_join=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubeadm token create --print-join-command")
echo $k8s_join

## Checking Maser Node Status
echo Checking Master Status $master_instance_id $master_instance_ip
state=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl get nodes |grep master |awk '{print \$2}'")
state1=$(echo "$state"|grep -c Ready)
echo state: $state $state1
while [[ "$state1" != "1" ]]
do
  state1=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl get nodes |grep master |awk '{print \$2}'")
  echo Current state $state
  sleep 15
done

## Node
#instance_id=$(aws ec2 describe-instances --filters "Name=tag:Role,Values=${env}-node" --output text --query 'Reservations[*].Instances[*].InstanceId')
#echo Node instance_id $instance_id
#instance_ip=$(aws ec2 describe-instances --instance-ids $instance_id \
#    --query 'Reservations[*].Instances[*].PublicIpAddress' \
#    --output text)
export instance_ip=$node_ips

echo Node instance_id $instance_id  $instance_ip
## Joining Nodes
for i in $instance_ip
do
  echo Joning Worker Node $i
  ssh -o StrictHostKeyChecking=no -i $key $user@$i "while [ ! -f /k8sdone ];do echo -e Waiting for k8s-deployment-init...;sleep 5; done"
  export myip=$(ssh -o StrictHostKeyChecking=no -i $key $user@$i "hostname -i")
  echo Checking Node Status PublicIP: $i PrviateIP: $myip before k8s_join
  state=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl get nodes |grep $myip |awk '{print \$2}'")
  state1=$(echo $state |grep -c Ready)
  echo Checking Node state for k8s_join: $state $state1
  if [[ "$state1" != "1" ]]
  then
    ssh -o StrictHostKeyChecking=no -i $key $user@$i "sudo $k8s_join"
  else
    echo "Already Joined $i $state"
  fi
done


for i in $instance_ip;
do
  echo Checking Worker Node status $i
  export myip=$(ssh -o StrictHostKeyChecking=no -i $key $user@$i "hostname -i")
  echo Checking Node Status: $myip after k8s_join
  state=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl get nodes |grep $myip |awk '{print \$2}'")
  echo state: $state
  while [[ "$state" != "Ready" ]]
  do
    state=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl get nodes |grep $myip |awk '{print \$2}'")
    echo Current state $state
    sleep 15
  done
  echo Node is UP $myip
done

echo "All Nodes are up"

## scale up coredns based on Node count
export count=$ec2_count
echo Updating CoreDNS Node Count $count
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl scale deployment --replicas=${count} coredns --namespace=kube-system"
echo Restarting coredns
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl -n kube-system rollout restart deploy coredns"
sleep 2m

echo Resting kubelet service
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo systemctl restart kubelet.service"

echo FINISH

echo TESTING CORDNS
sleep 2m
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl run busybox --image=busybox --rm -it --restart=Never --command -- nslookup kubernetes.default.svc.cluster.local"

## kubectl run busybox --image=busybox:1.28.4 --rm -it --restart=Never --command -- nslookup google.com
## kubectl run busybox --image=busybox --rm -it --restart=Never --command -- nslookup kubernetes.default.svc.cluster.local
