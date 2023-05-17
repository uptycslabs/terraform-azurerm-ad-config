# Get MSGraph App
resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

# Create a service principal for the Uptycs App 
resource "azuread_service_principal" "service_principal" {
  application_id = var.uptycs_app_client_id
  use_existing   = true
}

# Create Graph API related permissions to the service principal
resource "azuread_app_role_assignment" "application_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Application.Read.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "user_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "directory_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Directory.Read.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "organization_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Organization.Read.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "group_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Group.Read.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "on_premises_publishing_profiles_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["OnPremisesPublishingProfiles.ReadWrite.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "audit_log_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["AuditLog.Read.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "policy_reader_role" {
  count = var.use_existing_service_principal ? 0 : 1
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Policy.Read.All"]
  principal_object_id = azuread_service_principal.service_principal.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

# Give the service principal a Reader role in the Subscription
resource "azurerm_role_assignment" "attach_reader_role" {
  principal_id         = azuread_service_principal.service_principal.id
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
}

# Give the service principal a Storage Blob Data Reader role in the Subscription
resource "azurerm_role_assignment" "storage_blob_data_reader_role" {
  principal_id         = azuread_service_principal.service_principal.id
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage Blob Data Reader"
}


resource "azurerm_role_assignment" "Attach_Key_Vault_Readerrole" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azuread_service_principal.service_principal.id
}

resource "azurerm_role_assignment" "Attach_StorageAccountKeyOperatorServicerole" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_service_principal.service_principal.id
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
  principal_id       = azuread_service_principal.service_principal.id
}


resource "azurerm_key_vault_access_policy" "attach_keyvalut_policy" {
  count        = length(data.azurerm_resources.Fetch_keyvalutids.resources)
  key_vault_id = data.azurerm_resources.Fetch_keyvalutids.resources[count.index].id
  tenant_id    = data.azurerm_subscription.primary.tenant_id
  object_id    = azuread_service_principal.service_principal.object_id

  key_permissions = []

  secret_permissions = []
  certificate_permissions = [
    "List",
    "Get"
  ]
  storage_permissions = []
}
