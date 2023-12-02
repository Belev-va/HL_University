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

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The compute engine machine type to use for server instances."
}

variable "instance_subnet_id" {
  type        =  list(string)
  default     = []
  description = "Subnet id for instance."
}

variable "instance_security_group" {
  type        =  list(string)
  default     = []
  description = "Security group for instance."
}



