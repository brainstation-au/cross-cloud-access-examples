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
  description = "The AWS region."
}

variable "google_project_id" {
  type        = string
  description = "The Google Cloud project ID."
}

variable "google_cloud_region" {
  type        = string
  description = "The Google Cloud region."
}
