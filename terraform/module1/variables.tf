variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0323c3dd2da7fb37d"
}
variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = "borin_devops_school"
}
variable "devops_school_tag" {
  description = "The tag to mark all objects that were created at devops school 2020"
  type        = string
  default     = "Epam_Devops_School_2020"
}
variable "nginx" {
  description = "Colon-separated name and tag for nginx container"
  type        = string
  default     = "nginx:stable"
}
variable "php" {
  description = "Colon-separated name and tag for php container"
  type        = string
  default     = "php:7.4-fpm"
}
variable "docker-net" {
  description = "Internal network name"
  type        = string
  default     = "epam"
}
variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}