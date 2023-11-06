output "OPEN_AI_ENDPOINT" {
  sensitive = true
  value     = module.my_openai.openai_endpoint
}

output "OPEN_AI_KEY" {
  sensitive = true
  value     = module.my_openai.openai_primary_key
}

output "SPEECH_KEY" {
  sensitive = true
  value     = azurerm_cognitive_account.watari-ai-speech.primary_access_key
}

output "SPEECH_REGION" {
  sensitive = true
  value     = azurerm_cognitive_account.watari-ai-speech.location
}

locals {
  random_string = random_string.random.result
}

output "SUFFEX" {
  value = random_string.random.result
}