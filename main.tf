terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vision2" {
  name     = "vision2"
  location = "East US"
  tags = {
    environment : "development"
  }
}

resource "azurerm_virtual_network" "vision2_vn" {
  name = "vision2_vn"
  tags = {
    environment : "development"
  }
  resource_group_name = azurerm_resource_group.vision2.name
  location = azurerm_resource_group.vision2.location
  address_space = ["10.0.0.0/16"]
}




