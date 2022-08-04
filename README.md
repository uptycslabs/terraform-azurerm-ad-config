# Terraform Azure Application Registration module

## Overview

* This module would help create access credentials to be used with Azure Account integration with Uptycs.
* The user should have `owner` role to create resources
* This terraform module will create following resources:-
  * Application
  * Service principal to the application
  * It will attach the following roles and permissions to the service principal
    * Reader
    * Key Vault Reader
    * Storage Account Key Operator Service Role
    * Custom Readonly access for required resources
    * Directory.Read.All
    * Access Policy(Keyvault - Key & Secret Management - List Keys, Secrets)

## 1. Authenticate

### 1a. Login to azure

```
$ az login
```

### 1b. Set a subscription

If the user has more than one subscription then set the subscription which you want to integrate with uptycs

```
$ az account set --subscription="SUBSCRIPTION_ID"
```

## 2. Steps to generate credentials

### 2a. Create a directory

```
mkdir <Name of the directory>
```

### 2b. Change directory

```
cd <Name of the directory created in step 2a>
```

### 2c. Create a file with name `main.tf` and paste below code

```
module "iam-config" {
  source     = "github.com/uptycslabs/terraform-azure-iam-config"

  # modify as you need
  resource_prefix = "uptycs-cloudquery-integration-123"
}

output "subscription_id" {
  value = module.iam-config.subscription_id
}

output "subscription_name" {
  value = module.iam-config.subscription_name
}
```

### Inputs


| Name            | Description                                | Type     | Default                         |
| ----------------- | -------------------------------------------- | ---------- | --------------------------------- |
| resource_prefix | Prefix to be used for naming new resources | `string` | `uptycs-cloudquery-integration-123` |

### 2d. Run Terraform

```sh
$ terraform init
$ terraform plan
$ terraform apply
```

Once terraform is applied successfully, it will create `client_credentials.json` file and will give below outputs

### Outputs


| Name              | Description                         |
| ------------------- | ------------------------------------- |
| subscription_id   | Subscriptionid of the Azure Account |
| subscription_name | Name of the the azure subscription  |

## 3. Enter the outputs in corresponding fields of Uptycs UI

3a. In Uptycs UI, paste the values of subscription_id and subscription_name in `Azure Subscription ID` and `Azure Subscription Name` fields respectively.

3b. Run this command to get credentilas

```
cat client_credentials.json | jq
```

3c. Paste the above command's output into Access Config JSON field
