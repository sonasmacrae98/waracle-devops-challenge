variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "waracle-rg"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "UK South"
}

variable "admin_public_key" {
  description = "SSH public key for VM login"
  type        = string
}
