locals {
  repository    = split("/", var.github_repository)[1]
  resource_name = "aws-lambda-to-gcp"
  tags = {
    Terraform  = "true"
    GithubOrg  = var.github_repository_owner
    GithubRepo = local.repository
  }
}
