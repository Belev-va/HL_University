variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The AWS region"
}

variable "instance_name" {
  type        = string
  default     = "FlureBlog-wp"
  description = "Instance name"
}

variable "instance_type" {
  type        = string
  default     = "micro_3_0"
  description = "Instance type"
}

variable "app" {
  type        = string
  default     = "wordpress"
  description = "blueprint_id"
}




