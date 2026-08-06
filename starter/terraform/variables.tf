variable "owner" {
  type = string
}

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

variable "shared_rg_name" {
  type = string
}

variable "shared_plan_name" {
  type = string
}

variable "postgres_version" {
  type    = string
  default = "16"
}

variable "postgres_sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  type    = number
  default = 32768
}

variable "postgres_admin_username" {
  type    = string
  default = "postgresadmin"
}

variable "postgres_admin_password" {
  type      = string
  sensitive = true
}

variable "postgres_database_name" {
  type    = string
  default = "appdb"
}

variable "redis_sku_name" {
  type    = string
  default = "Basic"
}

variable "static_webapp_sku" {
  type    = string
  default = "Free"
}

variable "backend_docker_image" {
  type    = string
  default = "quiz-backend:latest"
}

variable "github_repository" {
  type = string
}

variable "github_branch" {
  type    = string
  default = "main"
}

variable "tags" {
  type    = map(string)
  default = {}
}
