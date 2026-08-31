# Terraform AWS EC2 Cloud-Init Project

This project demonstrates deploying an AWS EC2 instance using **Terraform**, a custom **VPC**, and **cloud-init** automation.

## What We Built

* AWS VPC with a `10.0.0.0/16` CIDR block
* Public subnet with a `10.0.1.0/24` CIDR block
* Internet Gateway and public route table
* Security Group allowing HTTP and SSH traffic
* Reusable Terraform EC2 module
* EC2 instance using `t3.micro`
* Cloud-init configuration to automatically install and start Apache

## Project Structure

```text
project-2/
├── main.tf
├── provider.tf
├── variable.tf
├── vpc.tf
└── modules/
    └── ec2/
        ├── ec2.tf
        ├── variables.tf
        └── cloud-init.yaml
```

## Terraform Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Result

Terraform successfully deployed the AWS infrastructure and EC2 instance. Cloud-init automatically configured the server at boot without requiring manual software installation.

## Technologies

* Terraform
* AWS EC2
* AWS VPC
* AWS Security Groups
* AWS Internet Gateway
* Linux
* Apache
* Cloud-init
