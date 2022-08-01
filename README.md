# Terraform Azure Application Registration module
* This module would help create access credentials to be used with Azure Account integration with Uptycs.
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

## 1.Authenticate
```
$ az login
```
If the user has more than one subscriptions then set the subscription
```
$ az account set --subscription="SUBSCRIPTION_ID"
```
## 2.Create a <file.tf> file and paste below code and modify resource_prefix as you need

```
module "iam-config" {
  source     = "github.com/uptycslabs/terraform-azure-iam-config"
  resource_prefix = "uptycs-integration-123"
}

output "subscription_id" {
  value = module.iam-config.subscription_id
}

output "subscription_name" {
  value = module.iam-config.subscription_name
}

```

## Inputs

| Name | Description | Type | Default |
| ---- | ----------- | ---- | ------- |
| resource_prefix | Prefix to be used for naming new resources | `string` | `uptycs-cloudquery-integration`|

## 3. Execute Terraform script to get credentials JSON

```sh
$ terraform init
$ terraform plan
$ terraform apply
```
## Note:
* The user should have `owner` role to create resources
* Once terraform is applied successfully, it will create `client_credentials.json` file and will give outputs (azure subscription id and azure subscription name)
* The user has to paste these output values and the data in `client_credentials.json` in respective fields of uptycs UI  

## Outputs

| Name                    | Description      |
| ----------------------- | ---------------- |
| subscription_id        | Subscriptionid of the Azure Account  |
| subscription_name      | Name of the the azure subscription|