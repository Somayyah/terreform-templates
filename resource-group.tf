resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "azurerm_resource_group" "watari-ai" {
  depends_on = [random_string.random]
  name       = "watari-ai-${local.random_string}"
  location   = "Sweden Central"
  tags = {
    environment : "development"
  }
}
