variable "env" {
  type        = string
  description = "Prefix for all resources (w/o special cahrs)"
  default = "mklosalida"
}

variable "region" {
  type        = string
  description = "The location for resource deployment"
  default     = "westeurope"
}

variable "container-name" {
  type        = string
  description = "Name of sample container in storage account"
  default     = "demo"
}

variable "kv-client-id-secret-name" {
  type        = string
  description = "Name of secret with registered app client-id"
  default     = "client-id"
}

variable "kv-client-secret-secret-name" {
  type        = string
  description = "Name of secret with registered app client-secret"
  default     = "client-secret"
}

variable "AzureDatabricks_app_id" {
  description = "ID of AzureDatabricks enterprise app - don't change :)"
  type        = string
  sensitive   = true
  default     = "6ac04a60-f9ee-4fb3-8a2b-85956a051c15"
}