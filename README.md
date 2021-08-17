# Terraform Azure Application Registration module
* This module allows you to Register an application with required roles and permissions and return Clientid and ClientSecret
* This module will register an application and create Service principal with following roles attached:
  * Reader
  * Reader and Data Access
  * Custom Readonly access for required resources
  
## 1.Create a <file.tf> file and paste below code and modify as you needed

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


## 2. Execute Terraform script to get ClientId and ClientSecret

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