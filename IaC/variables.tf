#General variables
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to deploy resources in."
}
variable "stand_name" {
  type        = string
  default     = "dev"
  description = "name for stand"
}
