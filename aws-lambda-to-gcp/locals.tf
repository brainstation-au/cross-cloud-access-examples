locals {
  repository        = split("/", var.github_repository)[1]
  resource_name     = "aws-lambda-to-gcp"
  aws_iam_role_path = "/github/brainstation-au/${local.repository}/"
  tags = {
    Terraform  = "true"
    GithubOrg  = var.github_repository_owner
    GithubRepo = local.repository
  }
}
