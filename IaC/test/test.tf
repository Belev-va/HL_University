terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  access_key = file("../access.txt")
  secret_key = file("../secret.txt")
  region     = var.region
}


module "network" {
  source = "../modules/network"
  name = "test"
  create_private_subnets = false
}

module "key-pair" {
  source = "../modules/key-pair"

}

module "security_group"{
  source       = "../modules/security_group"
  vpc_id       = module.network.vpc_id
  private_cidr = module.network.public_cidr
  create_private_sg  = false
}

module "private_instance" {
  source                  = "../modules/instance"
  instance_name           = "dev_private"
  instance_subnet_id      = module.network.private_subnet_id
  instance_security_group = [module.security_group.private_security_group_id]
  instance_count          =  0
  instance_key_name       = module.key-pair.key_name
}

module "public_instance" {
  source                  = "../modules/instance"
  instance_name           = "dev_public"
  aws_ami = "ami-0866a3c8686eaeeba"
  instance_count          = 1
  instance_subnet_id      = module.network.public_subnet_id
  instance_security_group = [module.security_group.public_security_group_id]
  instance_key_name       = module.key-pair.key_name

}

