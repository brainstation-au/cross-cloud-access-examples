data "aws_ecr_authorization_token" "this" {}
data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "this" {
  name = local.app_name
}

resource "aws_iam_role" "this" {
  name = local.app_name
  path = local.aws_iam_role_path
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]
}

resource "aws_lambda_function" "this" {
  function_name = local.app_name
  role          = aws_iam_role.this.arn
  architectures = ["arm64"]
  description   = "This is an example lambda function"
  image_uri     = "${local.image_name}@${docker_registry_image.this.sha256_digest}"
  environment {
    variables = {
      GOOGLE_IDENTITY_PROVIDER = var.gcp_identity_provider
      GOOGLE_PROJECT_ID        = var.google_project_id
      GCS_BUCKET_NAME          = google_storage_bucket.this.name
    }
  }
  package_type = "Image"
  timeout      = 60
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
}
