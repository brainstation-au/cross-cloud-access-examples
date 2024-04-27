variable "github_repository" {
  type        = string
  description = "The owner and repository name. For example, octocat/Hello-World."
}

variable "github_repository_owner" {
  type        = string
  description = "The repository owner's username. For example, octocat."
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources."
}

variable "google_project_id" {
  type        = string
  description = "The Google Cloud project ID."
}

variable "gcp_identity_pool_for_aws" {
  type        = string
  description = "The GCP identity pool for AWS."
}

variable "app_name" {
  type        = string
  description = "The name of the application."
}

variable "image_uri" {
  type        = string
  description = "ECR image URI."
  default     = ""
}
