#Variables for sg
variable "allowed_public_ports" {
  description = "Список портов для открытия"
  type        = list(number)
  default     = [80, 2222, 22, 443, 8080]  # Здесь можно указать любые порты
}

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

variable "create_private_sg" {
  description = "Определяет, создавать ли private security group"
  type        = bool
  default     = true
}

variable "create_public_sg" {
  description = "Определяет, создавать ли public security group"
  type        = bool
  default     = true
}



