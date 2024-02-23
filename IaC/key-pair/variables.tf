#Variables for key pair
variable "key_name" {
  type        = string
  default     = "deployer-key"
  description = "Name for key pair"
}
variable "public_key" {
  type        = string
  default     = "terraform_ec2_key2.pub"
  description = "The name of public key file"
}


