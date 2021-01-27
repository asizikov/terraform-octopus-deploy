resource "octopusdeploy_environment" "test" {
  description = "azure function"
  name        = var.environmentName
}

resource "octopusdeploy_azure_service_principal" "azure" {
  subscription_id =  var.azure_subscription_id
  name            = "Azure Subscpription"
  tenant_id       =  var.azure_tenant_id
  application_id  =  var.azure_application_id
  password        =  var.azure_password
}

resource "octopusdeploy_deployment_target" "azure" {
  environments = [octopusdeploy_environment.test.id]
  name         = "Echo Api"
  roles        = ["echo-api"]
  endpoint {
    communication_style = "AzureWebApp"
    web_app_name        = var.azure_web_app_name 
    resource_group_name = var.azure_web_app_rg_name
    account_id          = octopusdeploy_azure_service_principal.azure.id
  }
}