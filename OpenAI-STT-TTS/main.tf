data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "watari-ai" {
  name     = "watari-ai"
  location = "UK South"
  tags = {
    environment : "development"
  }
}

resource "azurerm_key_vault" "watari-ai-key-vault" {
  name                        = "watari-ai-key-vault"
  location                    = azurerm_resource_group.watari-ai.location
  tags                        = azurerm_resource_group.watari-ai.tags
  resource_group_name         = azurerm_resource_group.watari-ai.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}