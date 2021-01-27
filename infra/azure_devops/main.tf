resource "azuredevops_project" "project" {
  name       = "terraform-octopus-deploy"
  description        = "Octopus Deploy infra managed by Terraform"
  visibility = "public"

   features = {
      "testplans" = "disabled"
      "artifacts" = "disabled"
      "pipelines" = "enabled"
      "boards" = "disabled"
      "repositories" = "disabled"
  }
}


resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "GitHub"

  auth_personal {
    # Also can be set with AZDO_GITHUB_SERVICE_CONNECTION_PAT environment variable
    personal_access_token = "xxxxxxxxxxxxxxxxxxxx"
  }
}