terraform workspace select -or-create dev

terraform plan -var-file value.tfvars -out=planoutput
terraform plan -var-file value.tfvars > plan-dryrun

terraform apply planoutput
