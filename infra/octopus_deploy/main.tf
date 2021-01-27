resource "octopusdeploy_azure_service_principal" "azure" {
  subscription_id =  var.azure_subscription_id
  name            = "Azure Subscpription"
  tenant_id       =  var.azure_tenant_id
  application_id  =  var.azure_application_id
  password        =  var.azure_password
}

resource "octopusdeploy_environment" "test" {
  description = "azure function"
  name        = var.environmentName
  depends_on = [ octopusdeploy_azure_service_principal.azure ]
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

data "octopusdeploy_feeds" "builtin" {
  feed_type = "BuiltIn"
}


resource "octopusdeploy_lifecycle" "default" {
  name = "Default Lifecycle"
}

resource "octopusdeploy_project_group" "default" {
  name = "Default Project Group"
  description = "Azure Echo Function"
}

resource "octopusdeploy_project" "echo-api" {
  name = "Echo Api"
  lifecycle_id = octopusdeploy_lifecycle.default.id
  project_group_id = octopusdeploy_project_group.default.id
}

data "octopusdeploy_machine_policies" "default" {
}

resource "octopusdeploy_deployment_process" "deployment" {
  project_id = octopusdeploy_project.echo-api.id
  step {
    name = "Deploy Function"
    target_roles = ["echo-api"]
    action {
      name = "Deploy Function"
      action_type = "Octopus.AzureWebApp"
      environments = [octopusdeploy_environment.test.id]
      package {
        name = ""
        package_id = "func"
        feed_id = data.octopusdeploy_feeds.builtin.feeds[0].id
      }
    }
  }
}
