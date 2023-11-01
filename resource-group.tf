resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "azurerm_resource_group" "watari-ai" {
  name     = "watari-ai-${local.random_string}"
  location = "Sweden Central"
  tags = {
    environment : "development"
  }
}
