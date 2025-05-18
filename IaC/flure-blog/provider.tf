terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }
}

provider "aws" {
  access_key = file("../access.txt")
  secret_key = file("../secret.txt")
  region     = var.region
}
