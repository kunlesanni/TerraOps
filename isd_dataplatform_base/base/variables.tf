variable "location" {
  type        = string
  default     = "uksouth"
  description = "The location/region where the resources will be created."
}

variable "rg" {
  type        = string
  description = "The name of the resource group in which the resources will be created."
}

variable "kv" {
  type        = string
  description = "The name of the key vault."
}

variable "kv_admin_roleid" {
  type        = string
  description = "The role id of the key vault administrator rbac role."
}

variable "kv_secret_names" {
  type        = list(string)
  description = "The list of secret names to create in the key vault."
}

variable "law" {
  type        = string
  description = "The name of the log analytics workspace."
}

variable "sa" {
  type        = string
  description = "The name of the storage account."
}

variable "datalake" {
  type        = string
  description = "The name of the datalake storage account."
}

variable "email" {
  type        = string
  description = "The email address to send alerts to."

}

variable "tags" {
  description = "The tags to associate with your deployed resources."
}

variable "envr" {
  type        = string
  description = "(optional) describe your variable"
}