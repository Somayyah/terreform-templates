output "OPEN_AI_ENDPOINT" {
  sensitive = true
  value     = azurerm_cognitive_account.watari-ai-aoai.endpoint
}

output "OPEN_AI_KEY" {
  sensitive = true
  value     = azurerm_cognitive_account.watari-ai-aoai.primary_access_key
}

output "SPEECH_KEY" {
  sensitive = true
  value     = azurerm_cognitive_account.watari-ai-speech.primary_access_key
}

output "SPEECH_REGION" {
  sensitive = true
  value     = azurerm_cognitive_account.watari-ai-speech.location
}
