variable "github_repository" {
  type        = string
  description = "The owner and repository name. For example, octocat/Hello-World."
}

variable "github_repository_owner" {
  type        = string
  description = "The repository owner's username. For example, octocat."
}

variable "google_project_id" {
  type        = string
  description = "The Google Cloud project ID."
}

variable "google_cloud_region" {
  type        = string
  description = "The Google Cloud region. For example, australia-southeast1."
}

variable "gcp_identity_pool" {
  type        = string
  description = "The Google Cloud identity pool name."
}

variable "gcp_identity_provider" {
  type        = string
  description = "The Google Cloud identity provider name."
}

variable "azure_subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "azure_resource_group_name" {
  type        = string
  description = "The Azure resource group name."
}

variable "azure_resource_group_location" {
  type        = string
  description = "The Azure resource location. For example, australiaeast."
}

variable "docker_hub_username" {
  type        = string
  description = "The Docker Hub username."
}

variable "docker_hub_access_token" {
  type        = string
  description = "The Docker Hub access token."
  sensitive   = true
}
