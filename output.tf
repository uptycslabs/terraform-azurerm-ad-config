output "Subscription_ID" {
  value = data.azurerm_subscription.primary.subscription_id
}
output "Application_ID" {
  value = azuread_application.application_registration.application_id
}
output "Tenant_ID" {
  value = data.azurerm_subscription.primary.tenant_id
}

output "Object_ID" {
  value = azuread_application.application_registration.object_id
}

output "Client_Secret" {
  value     = azuread_application_password.password_generation.value
  sensitive = true
}

output "Client_Secret_ID" {
  value = azuread_application_password.password_generation.key_id

}