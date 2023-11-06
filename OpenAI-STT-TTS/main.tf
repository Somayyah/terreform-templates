// Create Azure OpenAI resource

module "my_openai" {
  depends_on                    = [azurerm_resource_group.watari-ai]
  source                        = "./modules/my_openai"
  account_name                  = "watari-ai-aoai-${local.random_string}"
  resource_group_name           = azurerm_resource_group.watari-ai.name
  location                      = azurerm_resource_group.watari-ai.location
  public_network_access_enabled = true
  deployment = {
    "chat_model" = {
      name          = "watari-ai-aoai-cd-${local.random_string}"
      model_format  = "OpenAI"
      model_name    = "gpt-4"
      model_version = "0613"
      scale_type    = "Standard"
    }
  }

}
// Create Azure Speech resource

resource "azurerm_cognitive_account" "watari-ai-speech" {
  depends_on          = [azurerm_resource_group.watari-ai]
  name                = "watari-ai-speech-${local.random_string}"
  location            = azurerm_resource_group.watari-ai.location
  resource_group_name = azurerm_resource_group.watari-ai.name
  kind                = "SpeechServices"
  sku_name            = "S0"
  tags                = azurerm_resource_group.watari-ai.tags
}

// Azure cognitive search service
/* 
resource "azurerm_search_service" "watari-ai-search" {
  name                = "watari-ai-search-${local.random_string}"
  resource_group_name = azurerm_resource_group.watari-ai.name
  location            = azurerm_resource_group.watari-ai.location
  sku                 = "standard"

  local_authentication_enabled = false
}

resource "azurerm_storage_account" "watari-ai-db" {
  name                     = "watari-ai-db-${local.random_string}"
  resource_group_name      = azurerm_resource_group.watari-ai.name
  location                 = azurerm_resource_group.watari-ai.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_search_shared_private_link_service" "watari-ai-search-shared-priv-link" {
  name               = "watari-ai-search-shared-priv-link-${local.random_string}"
  search_service_id  = azurerm_search_service.watari-ai-search.id
  subresource_name   = "data"
  target_resource_id = azurerm_storage_account.watari-ai-db.id
  request_message    = "please approve"
} */