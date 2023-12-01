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
  access_key = file("access.txt")
  secret_key = file("secret.txt")
  region     = var.region
}


module "network" {
  source = "./network"

}

module "instance" {
  source         = "./instance"
  instance_subnet_id = module.network.private_subnet_id
  instance_security_group =module.network.default_security_group

}

