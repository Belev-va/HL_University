#General variables
variable "instance_count" {
  type        = string
  default     = "2"
  description = "Count of instances"
}
variable "instance_name" {
  type        = string
  default     = "dev"
  description = "Name for instances."
}
variable "aws_ami" {
  type       = string
  default    = "ami-0ff8a91507f77f867"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The EC2 instance type to use for server instances."
}

variable "instance_subnet_id" {
  type        = list(string)
  default     = []
  description = "Subnet id for instance."
}

variable "instance_security_group" {
  type        = list(string)
  default     = []
  description = "Security group for instance."
}

variable "instance_key_name" {
  type        = string
  default     = "deployer-key"
  description = "Key name for instance"
}

variable "user_data_file" {
  description = "The name of the user data file"
  type        = string
  default     = "./scripts/git_and_docker.sh"  # Укажите файл по умолчанию, если не передан другой
}
variable "ssh_private_key" {
  type        = string
  default     = "id_ed25519"
  description = "The name of public key file"
}

