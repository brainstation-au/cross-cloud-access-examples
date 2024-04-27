locals {
  repository        = split("/", var.github_repository)[1]
  aws_iam_role_path = "/github/brainstation-au/${local.repository}/"
  tags = {
    terraform   = "true"
    github_org  = var.github_repository_owner
    github_repo = local.repository
  }
}
