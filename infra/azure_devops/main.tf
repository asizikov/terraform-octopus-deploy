resource "azuredevops_project" "project" {
  name        = "terraform-octopus-deploy"
  description = "Octopus Deploy infra managed by Terraform"
  visibility  = "public"

  features = {
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "pipelines"    = "enabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
  }
}


resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "GitHub"

  auth_personal {
    personal_access_token = var.git_hub_pat
  }
}

resource "azuredevops_build_definition" "build_definition" {
  project_id = azuredevops_project.project.id
  name       = "Build Pipeline"
  path       = "\\build"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.git_hub_repo_id
    branch_name           = "main"
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
    yml_path              = "build/pipeline.yaml"
  }
}