aws s3 ls
terraform init
terraform plan
terraform apply

### password connection from bastion host to other ec2
ssh -i ~/.ssh/mac2.pem ubuntu@<bastion IP>
ubuntu@ip-192-168-0-6:~$ eval $(ssh-agent)

ubuntu@ip-192-168-0-6:~$ cat > ~/.ssh/mac2.pem

ubuntu@ip-192-168-0-6:~$ chmod 600 ~/.ssh/mac2.pem
ubuntu@ip-192-168-0-6:~$ ssh-add ~/.ssh/mac2.pem
ubuntu@ip-192-168-0-6:~$ ssh-add -l


ubuntu@ip-192-168-0-6:~$ ssh ubuntu@<Private ec2 IP>


