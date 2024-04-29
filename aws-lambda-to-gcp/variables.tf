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

variable "gcp_identity_pool" {
  type        = string
  description = "The Google Cloud identity pool name."
}

variable "gcp_identity_provider" {
  type        = string
  description = "The Google Cloud identity provider name."
}
