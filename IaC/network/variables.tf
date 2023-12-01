#General variables for network
variable "name" {
  type        = string
  default     = "dev"
  description = "tag for stage"
}
variable "cidr_vpc" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr block for vpc"
}
variable "cidr_public_subnet" {
  type        = string
  default     = "10.0.3.0/24"
  description = "cidr block for public subnet"
}
variable "cidr_private_subnet" {
  type        = string
  default     = "10.0.2.0/24"
  description = "cidr block for private subnet"
}
variable "availability_zone_public" {
  type        = string
  default     = "us-east-1b"
  description = "availability zone for public subnet"
}
variable "availability_zone_private" {
  type        = string
  default     = "us-east-1c"
  description = "availability zone for public subnet"
}


