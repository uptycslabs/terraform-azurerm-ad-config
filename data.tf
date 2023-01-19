data "azurerm_subscription" "primary" {
}

data "azurerm_resources" "Fetch_keyvalutids" {
  type = "Microsoft.KeyVault/vaults"
}

data "azuread_application_published_app_ids" "well_known" {}
