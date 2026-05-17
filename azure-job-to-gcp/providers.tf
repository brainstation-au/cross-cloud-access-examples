terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.34"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 6.41"
    }
  }

  backend "gcs" {
    bucket                      = "brainstation-terraform"
    prefix                      = "cross-cloud-access-examples/azure-job-to-gcp/terraform-state"
    impersonate_service_account = "project-admin@cross-cloud-access-examples.iam.gserviceaccount.com"
  }

  required_version = "~> 1.12"
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

provider "docker" {
  registry_auth {
    address  = local.image_registry
    username = var.docker_hub_username
    password = var.docker_hub_access_token
  }
}

provider "google" {
  project                     = var.google_project_id
  region                      = var.google_cloud_region
  impersonate_service_account = "project-admin@cross-cloud-access-examples.iam.gserviceaccount.com"
  default_labels              = local.tags
}
