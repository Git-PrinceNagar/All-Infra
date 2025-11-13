terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }

   backend "azurerm" {
      # resource_group_name = "rg-prince-state-dev"
      # storage_account_name = "stprinceprod28019"
      # container_name = "tfprincestate"
      # key = "ttt.tfstate"
    }

}
provider "azurerm" {
  features {}
  subscription_id = "9e25d220-6410-4a47-8e3e-22042c54587d"
  }
 