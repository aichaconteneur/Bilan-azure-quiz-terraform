locals {
  tags = merge(
    var.tags,
    {
      owner       = var.owner
      project     = var.project
      environment = var.environment
      managed_by  = "terraform"
    }
  )
}
