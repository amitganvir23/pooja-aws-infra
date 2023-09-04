#! /bin/bash
#env=test
env=$(echo $(grep '^environment' terraform.tfvars|awk '{print $3}'|tr -d '"'))
echo Environment is $env

instance_id=$(aws ec2 describe-instances --filters "Name=tag:Role,Values=${env}-server" --output text --query 'Reservations[*].Instances[*].InstanceId')
echo

instance_ip=$(aws ec2 describe-instances --instance-ids $instance_id \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \
    --output text)
echo Server Server instance_id $instance_id $instance_ip

k8s_join=$(ssh -i ~/.ssh/mac2.pem ubuntu@$instance_ip "sudo kubeadm token create --print-join-command")

instance_id=$(aws ec2 describe-instances --filters "Name=tag:Role,Values=${env}-node" --output text --query 'Reservations[*].Instances[*].InstanceId')
echo Node instance_id $instance_id

instance_ip=$(aws ec2 describe-instances --instance-ids $instance_id \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \
    --output text)
echo Node instance_id $instance_id  $instance_ip

for i in $instance_ip;
do
  echo Joning Worker Node $i
  ssh -i ~/.ssh/mac2.pem ubuntu@$i "sudo $k8s_join"
done

