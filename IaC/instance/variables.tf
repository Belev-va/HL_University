#General variables
variable "instance_count" {
  type        = string
  default     = "3"
  description = "Count of instances"
}

variable "instance_ami_id" {
  type        = string
  default     = "ami-0dcc1e21636832c5d"
  description = "The ami id for instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The compute engine machine type to use for server instances."
}
variable "instance_subnet_id" {
  type        = string
  default     = ""
  description = "Subnet id for instance."
}
variable "instance_name" {
  type        = string
  default     = "dev_instance"
  description = "Name for instances."
}
variable "instance_security_group" {
  type        = string
  default     = ""
  description = ""
}


