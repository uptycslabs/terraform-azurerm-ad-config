resource "azuread_application" "application_registration" {
  display_name = "${var.resource_prefix}"
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"
    resource_access {
      id   = "5778995a-e1bf-45b8-affa-663a9f3f4d04"
      type = "Role"
    }
  }


}
resource "azuread_service_principal" "serviceprincipal" {
  application_id = azuread_application.application_registration.application_id
}
resource "azuread_application_password" "password_generation" {
  application_object_id = azuread_application.application_registration.object_id
  end_date_relative     = "43200h"
  display_name          = "cloudquery"
}

resource "azurerm_role_assignment" "Attach_Readerrole" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.serviceprincipal.id
}

resource "azurerm_role_assignment" "Attach_Key_Vault_Readerrole" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azuread_service_principal.serviceprincipal.id
}

resource "azurerm_role_assignment" "Attach_StorageAccountKeyOperatorServicerole" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_service_principal.serviceprincipal.id
}

resource "azurerm_role_definition" "Define_App_Service_Auth_Reader" {
  name        = "${var.resource_prefix}-AppServiceAuthReader"
  scope       = data.azurerm_subscription.primary.id
  description = "Read permissions for authentication/authorization data related to Azure App Service"

  permissions {
    actions = ["Microsoft.Web/sites/config/list/Action"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

resource "azurerm_role_assignment" "Attach_App_Service_Auth_Reader" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.Define_App_Service_Auth_Reader.role_definition_resource_id
  principal_id       = azuread_service_principal.serviceprincipal.id
}


resource "azurerm_key_vault_access_policy" "attach_keyvalut_policy" {
  count        = length(data.azurerm_resources.Fetch_keyvalutids.resources)
  key_vault_id = data.azurerm_resources.Fetch_keyvalutids.resources[count.index].id
  tenant_id    = data.azurerm_subscription.primary.tenant_id
  object_id    = azuread_service_principal.serviceprincipal.object_id

  key_permissions = []

  secret_permissions = [
    "List",
  ]
  storage_permissions = []
}


resource "local_file" "Credentails" {
  content = jsonencode({
    "clientId"                       = "${azuread_application.application_registration.application_id}",
    "clientSecret"                   = "${azuread_application_password.password_generation.value}",
    "subscriptionId"                 = "${data.azurerm_subscription.primary.subscription_id}",
    "tenantId"                       = "${data.azurerm_subscription.primary.tenant_id}",
    "activeDirectoryEndpointUrl"     = "https://login.microsoftonline.com",
    "resourceManagerEndpointUrl"     = "https://management.azure.com/",
    "activeDirectoryGraphResourceId" = "https://graph.windows.net/",
    "sqlManagementEndpointUrl"       = "https://management.core.windows.net=8443/",
    "galleryEndpointUrl"             = "https://gallery.azure.com/",
    "managementEndpointUrl"          = "https://management.core.windows.net/"
  })
  filename = "client_credentials.json"
}