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

variable "service_plan_name" {
  type = string
}

variable "service_plan_resource_group_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "container_registry_login_server" {
  type = string
}

variable "docker_image_name" {
  type = string
}

variable "postgres_host" {
  type = string
}

variable "redis_host" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
