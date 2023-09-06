#! /bin/bash
#env=test
### its only for Ubuntu

export user=ubuntu
#export key="~/.ssh/mac2.pem"
export env=$env
export key=$key
#env=$(echo $(grep '^environment' terraform.tfvars|awk '{print $3}'|tr -d '"'))
echo Environment is $env

## Master
master_instance_id=$(aws ec2 describe-instances --filters "Name=tag:Role,Values=${env}-server" --output text --query 'Reservations[*].Instances[*].InstanceId')
export master_instance_ip=$(aws ec2 describe-instances --instance-ids $master_instance_id \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \
    --output text)
echo Server Server master_instance_id $master_instance_id $master_instance_ip
export k8s_join=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubeadm token create --print-join-command")

## Checking Maser Node Status
#sleep 2m
echo Checking Master Status $master_instance_id $master_instance_ip
#sleep 60
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
instance_id=$(aws ec2 describe-instances --filters "Name=tag:Role,Values=${env}-node" --output text --query 'Reservations[*].Instances[*].InstanceId')
echo Node instance_id $instance_id
instance_ip=$(aws ec2 describe-instances --instance-ids $instance_id \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \
    --output text)
echo Node instance_id $instance_id  $instance_ip

for i in $instance_ip;
do
  echo Joning Worker Node $i
  ssh -o StrictHostKeyChecking=no -i $key $user@$i "sudo $k8s_join"
done

## master side
for i in $instance_ip;
do
  myip=$(ssh -o StrictHostKeyChecking=no -i $key $user@$i "hostname -i")
  echo Checking Node Status $i $myip
  sleep 30
  state=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl get nodes |grep $myip |awk '{print \$2}'")
  echo state: $state
  while [[ "$state" != "Ready" ]]
  do
    state=$(ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl get nodes |grep $myip |awk '{print \$2}'")
    echo Current state $state
    sleep 15
  done
done

echo "All Nodes are up"

echo Restarting coredns
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl -n kube-system rollout restart deploy coredns"
sleep 15
echo Resting kubelet service
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo systemctl restart kubelet.service"

echo FINISH

echo TESTING CORDNS
sleep 30
ssh -o StrictHostKeyChecking=no -i $key $user@$master_instance_ip "sudo kubectl run busybox --image=busybox --rm -ti --restart=Never --command -- nslookup kubernetes.default.svc.cluster.local"

## kubectl run busybox --image=busybox:1.28.4 --rm -ti --restart=Never --command -- nslookup google.com
## kubectl run busybox --image=busybox --rm -ti --restart=Never --command -- nslookup kubernetes.default.svc.cluster.local