#General variables
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to deploy resources in."
}
variable "stage_dev" {
  type        = string
  default     = "dev"
  description = "name for stage"
}
variable "stage_test" {
  type        = string
  default     = "test"
  description = "name for stage"
}
variable "stage_prod" {
  type        = string
  default     = "prod"
  description = "name for stage"
}