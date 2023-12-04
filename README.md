Descriptions and launching instructions
---
This repository contains 3 sections: IaC, Docker and Programming. Each block has its own requirements.

-----------------------------------
### 1. IaC. This section contains terraform code for deploy infrastracture to AWS.
Requirements:
You will need terraform installed, AWS account and a pair of keys for ssh connection. 

***Warning: NAT Gateway is not provided within AWS Free Tier and costs $0.045 per hour***

1. Check out **IaC** directory and file structure. The current configuration will create a virtual network with 1 private and 1 public subnet. To access the Internet from a public network Internet gateway will be created for a private nat gateway. Route tables and associations between gateways and subnets will also be created. 3 servers will be created, 2 in a private subnet and one in a public subnet.
  In the security group module, 2 security groups and a key pair are created. First group for ssh connect to the machine in a public network from your computer. Second security group allows connection via ssh from a public subnet to a private subnet. 
  The **network** and **instances** are described as modules. Modules are initialized in the **dev_stand.tf** file. You can change parameters to modules for create another infrastructure. The parameters accepted are only those described in the **variables.tf** file of appropriate module.
2.  Go to folder IaC and add 3 secret files: access.txt and secret.txt keys for your AWS User with administrator permissions. And terraform_ec2_key.pub - public key from your ssh key pair. Than run command: **terraform init** for initialization, **terraform plan** for preview the changes and **terraform apply** for deploy infrastracture. 

