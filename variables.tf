variable "resource_group_name" {
  type        = string
  description = "azure resource group"
}

variable "resource_group_location" {
  type        = string
  description = "description"
}

variable "app_service_plan_name" {
  type        = string
  default     = ""
  description = "description"
}

variable "app_service_name" {
  type        = string
  default     = ""
  description = "description"
}

variable "sql_server_name" {
  type        = string
  default     = ""
  description = "description"
}

variable "sql_database_name" {
  type        = string
  default     = ""
  description = "description"
}

variable "sql_admin_login" {
  type        = string
  default     = ""
  description = "description"
}

variable "sql_admin_password" {
  type        = string
  default     = ""
  description = "description"
}

variable "firewall_rule_name" {
  type        = string
  default     = ""
  description = "description"
}

variable "repo_url" {
  type        = string
  default     = ""
  description = "description"
}





