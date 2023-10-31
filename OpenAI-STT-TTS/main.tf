// Create Azure OpenAI resource

resource "azurerm_cognitive_account" "watari-ai-aoai" {
  name                = "watari-ai-aoai"
  location            = azurerm_resource_group.watari-ai.location
  resource_group_name = azurerm_resource_group.watari-ai.name
  kind                = "OpenAI"

  sku_name = "S0"

  tags = azurerm_resource_group.watari-ai.tags
}

// Create Azure Speech resource

resource "azurerm_cognitive_account" "watari-ai-speech" {
  name                = "watari-ai-speech"
  location            = azurerm_resource_group.watari-ai.location
  resource_group_name = azurerm_resource_group.watari-ai.name
  kind                = "SpeechServices"

  sku_name = "S0"

  tags = azurerm_resource_group.watari-ai.tags
}