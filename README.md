Descriptions and launching instructions
---
This repository contains 3 sections: IaC, Docker and Programming. Each block has its own requirements.

-----------------------------------
### 1. IaC. This section contains terraform code for deploy infrastracture to AWS.
Requirements:
You will need terraform installed, AWS account and a pair of keys for ssh connection. 

***Warning: NAT Gateway is not provided within AWS Free Tier and costs $0.045 per hour.***

1. Check out **IaC** directory and file structure. The current configuration will create a virtual network with 1 private and 1 public subnet. To access the Internet from a public network Internet gateway will be created for a private NAT gateway. Route tables and associations between gateways and subnets will also be created. 3 servers will be created, 2 in a private subnet and one in a public subnet.
  In the security group module, 2 security groups and a key pair are described. First group allows connection via ssh from your computer to the instance in a public network. Second security group allows connection via ssh from a public subnet to a private subnet. 
  The **network** and **instances** are described as modules. Modules are initialized in the **dev_stand.tf** file. You can change parameters to modules for create another infrastructure. The parameters accepted are only those described in the **variables.tf** file of appropriate module.
NOTE: the module **security_group** needs improvement. We must be able set ingress and egress rules to this module.
2.  Go to folder **IaC** and add 3 secret files: **access.txt** and **secret.txt** keys for your AWS User with administrator permissions. And **terraform_ec2_key.pub** - public key from your ssh key pair. Than run command: **terraform init** for initialization, **terraform plan** for preview the changes and **terraform apply** for deploy infrastracture.
3.  You can connect to instance on the public subnet with user ubuntu and your private key of ssh keys pair. You can connect to instances on a private network from a instance located on a public network with the same private key.


### 2. Docker. This section contains docker and config files for build and run 4 containers with Loki, Grafana, Promtail and nodeJS application.
Requirements:
You will need git, docker and docker compose installed on your instance. Open the following ports: 9990, 3300, 3100 on your instance.

1. Check out **Docker** directory and file structure. The current configuration will create and run 4 containers with Loki, Grafana, Promtail and nodeJS application.
  
2.  Go to **Docker** directory. Copy the repository nodeJS application: ```git clone git@github.com:digitalocean/sample-nodejs.git```. Than move **Dockerfile** and **.gitignore** files to **sample-nodejs** directory. Than use command ```docker compose up -d``` for build and pull images and run containers. Go to ***localhost:9990*** and check our nodeJS application. Go to ***localhost:3300*** and check Grafana and Loki. Open Home->Explore and choice ```container=node-app``` on the Label filters for show logs nodeJS application. For more detailed settings, change the configuration files in **config** and recreate images.

### 3. Programming. This section contains simple function for print prime numbers in selected range.
Requirements:
You will need python version 2.7.5 or higher installed on your instance.

1. Go to **Programming** directory and check out **script.py** file. Use ```python script.py``` for launch the script.
   



