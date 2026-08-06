terraform {

  backend "azurerm" {

    resource_group_name  = "aidialloRG"
    storage_account_name = "diallostorage2026"
    container_name       = "container-aca"
    key                  = "terraform.tfstate"

  }

}
