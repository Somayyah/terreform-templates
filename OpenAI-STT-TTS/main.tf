// Create Azure OpenAI resource

resource "azurerm_cognitive_account" "watari-ai-aoai" {
  name                = "watari-ai-aoai-${local.random_string}"
  location            = azurerm_resource_group.watari-ai.location
  resource_group_name = azurerm_resource_group.watari-ai.name
  kind                = "OpenAI"
  sku_name            = "S0"

  tags = azurerm_resource_group.watari-ai.tags
}

// Create Azure Speech resource

resource "azurerm_cognitive_account" "watari-ai-speech" {
  name                = "watari-ai-speech-${local.random_string}"
  location            = azurerm_resource_group.watari-ai.location
  resource_group_name = azurerm_resource_group.watari-ai.name
  kind                = "SpeechServices"

  sku_name = "S0"

  tags = azurerm_resource_group.watari-ai.tags
}

// Azure cognitive service OpenAI deployment

resource "azurerm_cognitive_deployment" "watari-ai-aoai-cd" {
  name                 = "watari-ai-aoai-cd-${local.random_string}"
  cognitive_account_id = azurerm_cognitive_account.watari-ai-aoai.id
  model {
    format  = "OpenAI"
    name    = "gpt-4"
    version = "0613"
  }

  scale {
    type = "Standard"
  }
}
