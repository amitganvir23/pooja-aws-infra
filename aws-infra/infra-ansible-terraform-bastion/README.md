# Terraform
## To create Real infrastructure environment for dev, test, prod, prep, uat, qa

### It will Create below infrastructure
- Launch Bastion Ec2 with SG and IAM-Role optional
- Launch Server Ec2 with SG and IAM-Role optional
- This will deploy one VPC with
    - Public subnets based on variables 
    - Private subnets based on variables
    - IGW - Ineterent Gateway
    - Nat-Gateway
    - Associated Route Tables
    - It wil Create Elastic IP automatically for NAT
  
### Directory Structure
- This "stack-deployment" dir contains main tf files. from here will set values and deploy Infrastructer
- main.tf file to execute modules
- terraform.tfvars for update values for infra
- Steps to Create:
  - `cd stack-deployment`
  - `terraform init`
  - `terraform plan`
  - `terraofrm apply`
- Steps to Destroy:
  - `cd stack-deployment`
  - `terraform destroy`
  
### It will DO
- It will create VPC with Public and Private Subnets
- It will launch bastion ec2 with volume and public subnet 
- It will launch server ec2 with volume and private subnet (optional)

