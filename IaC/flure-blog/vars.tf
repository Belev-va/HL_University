variable "region" {
  type        = string
  description = "The AWS region"
}

variable "instance_name" {
  type        = string
  description = "Instance name"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "app" {
  type        = string
  description = "blueprint_id"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "ssh_key_paths" {
  type        = list(string)
  description = "List of paths to public SSH key files"
}
