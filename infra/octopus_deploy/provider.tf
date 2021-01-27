terraform {
  required_providers {
    octopusdeploy = {
      source = "OctopusDeployLabs/octopusdeploy"
    }
  }
}

provider "octopusdeploy" {
  address  = var.serverURL
  api_key  = var.apiKey
  space_id = var.space_id
}