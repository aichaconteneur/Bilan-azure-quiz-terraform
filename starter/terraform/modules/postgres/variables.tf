variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "postgres_version" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "storage_mb" {
  type = number
}

variable "admin_username" {
  type    = string
  default = "postgresadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "database_name" {
  type    = string
  default = "appdb"
}

variable "tags" {
  type = map(string)
}
