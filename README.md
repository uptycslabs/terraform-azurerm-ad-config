# Terraform Azure Application Registration module
* This module allows you to register an application with required roles and permissions and create credentials JSON file
* This module will register an application and create service principal with following roles and permissions attached:
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
## 2.Create a <file.tf> file and paste below code and modify app_prefix as you need

```
module "iam-config" {
 source = "github.com/uptycslabs/terraform-azure-iam-config"

  app_prefix = "cloudquery"
  }
  
output "Subscriptionid" {
value=module.iam-config.Subscription_ID
}
output "Tenantid" {
value=module.iam-config.Tenant_ID
}
output "Applicationid" {
  value = module.iam-config.Application_ID
}
output "Objectid" {
  value = module.iam-config.Object_ID
}
output "ClientSecret" {
  value = module.iam-config.Client_Secret
  sensitive = true
}
output "ClientsecretId" {
    value=module.iam-config.Client_Secret_ID
}
```

## Inputs

| Name | Description | Type | Default |
| ---- | ----------- | ---- | ------- |
| app_prefix | Prefix to be used for naming new resources | `string` | `cloudquery`|

## Outputs

| Name                    | Description      |
| ----------------------- | ---------------- |
| Subscriptionid        | Subscriptionid  |
|  Tenantid  | TenantId |
|  Objectid | Objectid of the Application|
|  ClientSecret |  ClientSecret of the application |
|  Applicationid |   ClientID of the application |
| ClientsecretId | Secret ID |


## 3. Execute Terraform script to get credentials JSON

```sh
$ terraform init
$ terraform plan
$ terraform apply
```
## Note :
ClientSecret can be obtained by running
```sh
$ terraform output ClientSecret
```
