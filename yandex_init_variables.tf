variable "auth_token" {
  description = "Yandex OAuth token"
  type        = string
  default     = "XXXXXXXXXX"
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  default     = "b1gnn11476qh9v5sajs1"
}

variable "folder_id" {
  description = "Default folder ID"
  type        = string
  default     = "b1g0qk43ikvthopcg1r0"
}

variable "zone" {
  description = "Geo zone ID"
  type        = string
  default     = "ru-central1-a"
}
