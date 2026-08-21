terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "revadevopstfstate"
    container_name       = "tfstate"
    key                  = "aks-dev.tfstate"
  }
}
