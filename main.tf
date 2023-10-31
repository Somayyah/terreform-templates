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
  tags = azurerm_resource_group.watari-ai.tags
}

resource "azurerm_linux_virtual_machine" "watari-ai-linux-vm" {
  name                = "watari-ai-linux-vm"
  resource_group_name = azurerm_resource_group.watari-ai.name
  location            = azurerm_resource_group.watari-ai.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.watari-ai-nic.id,
  ]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/vm_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}