data "aws_organizations_organization" "brainstation" {}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id       = data.aws_caller_identity.current.account_id
  aws_organization_id  = data.aws_organizations_organization.brainstation.id
  aws_organization_arn = data.aws_organizations_organization.brainstation.arn
}
