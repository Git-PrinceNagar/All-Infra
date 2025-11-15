terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }

   backend "azurerm" {
    resource_group_name = "all-resources-group"
    storage_account_name = "stgprince20242"
    container_name = "cntprince22777"
    key = "dev.tfstate"
   }

}
provider "azurerm" {
  features {}
  subscription_id = "e2e106a3-4a7b-4443-b147-e1da8d501783"
  }
 