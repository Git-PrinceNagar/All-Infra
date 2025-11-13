terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }

   backend "azurerm" {}

}
provider "azurerm" {
  features {}
  subscription_id = "e2e106a3-4a7b-4443-b147-e1da8d501783"
  }
 