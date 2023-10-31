// Create Azure OpenAI resource

resource "azurerm_cognitive_account" "watari-ai-aoai" {
  name                = "watari-ai-aoai"
  location            = azurerm_resource_group.watari-ai.location
  resource_group_name = azurerm_resource_group.watari-ai.name
  kind                = "OpenAI"

  sku_name = "S0"

  tags = azurerm_resource_group.watari-ai.tags

}

module "openai" {
  source  = "Azure/openai/azurerm"
  version = "0.1.1"
  # insert the 2 required variables here
}


// Create Azure Speech resource

resource "azurerm_cognitive_account" "watari-ai-speech" {
  name                = "watari-ai-speech"
  location            = azurerm_resource_group.watari-ai.location
  resource_group_name = azurerm_resource_group.watari-ai.name
  kind                = "Speech"

  sku_name = "S0"

  tags = azurerm_resource_group.watari-ai.tags
}

// Create Azure cognitive deployment

resource "azurerm_cognitive_deployment" "watari-ai-cd" {
  name                 = "watari-ai-cd"
  cognitive_account_id = azurerm_cognitive_account.watari-ai-aoai.id
  model {
    format  = "OpenAI"
    name    = "gpt-4-32k"
    version = "1"
  }

  scale {
    type = "Standard"
  }
}