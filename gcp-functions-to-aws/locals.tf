locals {
  repository        = split("/", var.github_repository)[1]
  app_name          = "gcp-functions-to-aws"
  aws_iam_role_path = "/github/brainstation-au/${local.repository}/"
  tags = {
    terraform   = "true"
    github-org  = var.github_repository_owner
    github-repo = local.repository
  }
}
