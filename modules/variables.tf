variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "lamp"
}

variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

variable "zone_name" {
  description = "Resourse zone name"
  type        = string
  default     = "ru-central1-a"
}

variable "token" {
  description = "OAuth token"
  type        = string
}

variable "cloud_id" {
  description = "Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Default folder ID"
  type        = string
}