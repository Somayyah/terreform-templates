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

resource "azurerm_resource_group" "watari-ai" {
  name     = "watari-ai"
  location = "East US"
  tags = {
    environment : "development"
  }
}

resource "azurerm_virtual_network" "watari-ai-vn" {
  name                = "watari-ai-vn"
  tags                = azurerm_resource_group.watari-ai.tags
  resource_group_name = azurerm_resource_group.watari-ai.name
  location            = azurerm_resource_group.watari-ai.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "watari-ai-subnet" {
  name                 = "watari-ai-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.watari-ai-vn.name
  resource_group_name  = azurerm_resource_group.watari-ai.name
}

resource "azurerm_network_security_group" "watari-ai-sg" {
  name = "watari-ai-sg"
  resource_group_name = azurerm_resource_group.watari-ai.name
  location = azurerm_resource_group.watari-ai.location
  tags = azurerm_resource_group.watari-ai.tags
}