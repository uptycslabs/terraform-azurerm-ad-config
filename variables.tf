variable "resource_prefix" {
  description = "Pass prefix to identify Application and resources"
  type        = string
  default     = "uptycs-integration-123"
}

variable "uptycs_app_client_id" {
  description = "Client ID of Uptycs Multitenant App"
  type        = string
}

variable "use_existing_service_principal" {
  description = "If you are integrating a subscription for the first time, set the value to false. For the second or other subscription integrations in the same tenant, set the value to true."
  type        = bool
}