#Variables for sg

variable "name" {
  type        = string
  default     = "dev"
  description = "Name for stand"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "Vpc for sg"
}

variable "public_description" {
  type        = string
  default     = "Allow ingres for ports 22, 80, 443 from internet"
  description = "Description for sg"
}

variable "private_description" {
  type        = string
  default     = "Allow ingres for ports 22 from public subnet"
  description = "Description for sg"
}

variable "public_cidr" {
  type        =  list(string)
  default     = ["0.0.0.0/0"]
  description = "cidr block for vpc"
}

variable "private_cidr" {
  type        =  list(string)
  default     = ["0.0.0.0/32"]
  description = "cidr block for vpc"
}


