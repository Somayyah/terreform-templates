resource "azurerm_resource_group" "watari-ai" {
  name     = "watari-ai"
  location = "UK South"
  tags = {
    environment : "development"
  }
}
