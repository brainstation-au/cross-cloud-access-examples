terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.97.1"
    }

    google = {
      source  = "hashicorp/google"
      version = "5.22.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-backend"
    storage_account_name = "terradata"
    container_name       = "cross-cloud-access-examples"
    key                  = "gcp-functions-to-aws.tfstate"
    subscription_id      = "a41dafcb-2936-42b5-8796-d761f0cbe41e"
  }

  required_version = ">= 1.7.4"
}

provider "archive" {}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.tags
  }
}

provider "google" {
  project        = var.google_project_id
  region         = var.google_cloud_region
  default_labels = local.tags
}
