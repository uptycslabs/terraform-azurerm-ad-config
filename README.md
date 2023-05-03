# Terraform Azure module - Subscription Integration for Uptycs

This module provides the required Azure resources to integrate an Azure subscription with Uptycs.


It creates the following resources:

* Application
* Service principal to the application
* It attaches the following roles and permissions to the service principal:

  **Roles**:

  - Reader
  - Key Vault Reader
  - Storage Account Key Operator Service Role
  - Custom read-only access for required resources

  **API permissions**:

  - Directory.Read.All
  - User.Read.All
  - Group.Read.All
  - Application.Read.All
  - OnPremisesPublishingProfiles.ReadWrite.All
  - Organization.Read.All
  - AuditLog.Read.All

  **Policies**:

  - Key Vault Access Policy (certificate_permissions : List, Get)

## Prerequisites

Ensure you have the following privileges before you execute the Terraform Script:

* The user should have `owner` role in subscription to create resources
* Administrative roles:
  * Global administrator

## Authentication

To authenticate Azure, use the following commands:

**Login to azure**

```
$ az login
```

**Set a subscription**

If the user has more than one subscription then set the subscription which you want to integrate with uptycs

```
$ az account set --subscription="SUBSCRIPTION_ID"
```

## Terraform Script

To execute the Terraform script:

1. **Prepare .tf file**

   Create a `main.tf` file in a new folder. Copy and paste the following configuration and modify as required:

```
module "iam-config" {
  source     = "github.com/uptycslabs/terraform-azurerm-ad-config"

  # modify as you need
  resource_prefix = "uptycs-cloudquery-integration-123"
  
  # Find the client_id on Azure Integration page of Uptycs Web
  uptycs_app_client_id = "Client ID from Azure Integration page"
  
  # If you are integrating a subscription for the first time, set the value to false. 
  # For the second or multiple subscription integrations in the same tenant, set the value to true.
  use_existing_service_principal = false
}

output "subscription_id" {
  value = module.iam-config.subscription_id
}

output "subscription_name" {
  value = module.iam-config.subscription_name
}
```

**Init, Plan and Apply**

**Inputs**


| Name            | Description                                | Type     | Default                             |
| ----------------- | -------------------------------------------- | ---------- | ------------------------------------- |
| resource_prefix | Prefix to be used for naming new resources | `string` | `uptycs-integration-123` |
| uptycs_app_client_id | The Client ID of Uptycs Multi-tenant app | `string` | required |
| use_existing_service_principal | Whether to create a new service princial or use existing one | `boolean` | required |

**Outputs**


| Name              | Description                         |
| ------------------- | ------------------------------------- |
| subscription_id   | Subscriptionid of the Azure Account |
| subscription_name | Name of the the azure subscription  |

```sh
$ terraform init --upgrade
$ terraform plan # Please verify before applying
$ terraform apply
# Wait until successfully completed
```
