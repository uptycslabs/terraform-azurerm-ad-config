data "azurerm_subscription" "primary" {
}

data "azurerm_resources" "Fetch_keyvalutids" {
  type = "Microsoft.KeyVault/vaults"
}