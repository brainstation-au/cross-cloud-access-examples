terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.7"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 6.41"
    }
  }

  backend "gcs" {
    bucket                      = "brainstation-terraform"
    prefix                      = "cross-cloud-access-examples/gcp-functions-to-aws/terraform-state"
    impersonate_service_account = "project-admin@cross-cloud-access-examples.iam.gserviceaccount.com"
  }

  required_version = "~> 1.12"
}

provider "archive" {}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.tags
  }
}

provider "google" {
  project                     = var.google_project_id
  region                      = var.google_cloud_region
  impersonate_service_account = "project-admin@cross-cloud-access-examples.iam.gserviceaccount.com"
  default_labels              = local.tags
}
