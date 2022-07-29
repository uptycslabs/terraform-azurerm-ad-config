output "subscription_id" {
  value = data.azurerm_subscription.primary.subscription_id
}
output "subscription_name" {
  value = data.azurerm_subscription.primary.display_name
}