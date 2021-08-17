resource "azuread_application" "application_registration" {
  display_name     = "${var.app_prefix}"
 }
 resource "azuread_service_principal" "serviceprincipal" {
  application_id = azuread_application.application_registration.application_id
}
resource "azuread_application_password" "password_generation" {
  application_object_id = azuread_application.application_registration.object_id
  end_date_relative     = "4320h" # expire in 6 months
  display_name    = "cloudquery"
}

resource "azurerm_role_assignment" "Attach_Readerrole" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.serviceprincipal.id
}
resource "azurerm_role_assignment" "Attach_Reader_and_DataAccess_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azuread_service_principal.serviceprincipal.id
}
resource "azurerm_role_definition" "Define_ReadonlyRole" {
  name               = "${var.app_prefix}_NetworkContributor_Readerrole"
  scope              = data.azurerm_subscription.primary.id
  description        = "Read permissions for Network Contributor"

  permissions {
    actions     = ["Microsoft.Authorization/*/read",
    "Microsoft.ResourceHealth/availabilityStatuses/read",
    "Microsoft.Resources/subscriptions/resourceGroups/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}
resource "azurerm_role_assignment" "Attach_ReadonlyRole" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_id   = azurerm_role_definition.Define_ReadonlyRole.role_definition_resource_id
  principal_id         = azuread_service_principal.serviceprincipal.id
}

