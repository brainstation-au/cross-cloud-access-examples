locals {
  repository        = split("/", var.github_repository)[1]
  app_name          = "aws-lambda-to-gcp"
  aws_iam_role_path = "/github/brainstation-au/${local.repository}/"
  tags = {
    terraform   = "true"
    github_org  = var.github_repository_owner
    github_repo = local.repository
  }
}
