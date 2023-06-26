variable "bucket" {
  description = "Bucket name"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Force bucket destroy when terraform destroy"
  type        = bool
  default     = false
}

variable "public_access" {
  description = "Enable public access"
  type        = bool
  default     = false
}

variable "website" {
  description = "Static website host or redirect configuraton. keys: index_document, host_name, protocol"
  type        = any
  default     = {}
}
