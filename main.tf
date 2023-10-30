terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
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
  name                = "watari-ai-sg"
  resource_group_name = azurerm_resource_group.watari-ai.name
  location            = azurerm_resource_group.watari-ai.location
  tags                = azurerm_resource_group.watari-ai.tags
}

resource "azurerm_network_security_rule" "watari-ai-sgr1" {
  name                        = "watari-ai-sgr1"
  resource_group_name         = azurerm_resource_group.watari-ai.name
  network_security_group_name = azurerm_network_security_group.watari-ai-sg.name
  protocol                    = "Icmp"
  access                      = "Deny"
  priority                    = 100
  direction                   = "Inbound"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "watari-ai-sgr2" {
  name                        = "watari-ai-sgr2"
  resource_group_name         = azurerm_resource_group.watari-ai.name
  network_security_group_name = azurerm_network_security_group.watari-ai-sg.name
  priority                    = 101
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "watari-ai-s-n-sg-a" {
  subnet_id                 = azurerm_subnet.watari-ai-subnet.id
  network_security_group_id = azurerm_network_security_group.watari-ai-sg.id
}

resource "azurerm_public_ip" "watari-ai-ip" {
  name                = "watari-ai-public-ip"
  resource_group_name = azurerm_resource_group.watari-ai.name
  location            = azurerm_resource_group.watari-ai.location
  allocation_method   = "Static"
  tags                = azurerm_resource_group.watari-ai.tags
}

resource "azurerm_network_interface" "watari-ai-nic" { 
  name                = "watari-ai-nic"
  resource_group_name = azurerm_resource_group.watari-ai.name
  location            = azurerm_resource_group.watari-ai.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.watari-ai-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}