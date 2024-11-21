data "aws_caller_identity" "current" {}

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
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "this" {
  function_name    = local.app_name
  role             = aws_iam_role.this.arn
  architectures    = ["arm64"]
  description      = "Writing sample object to GCS bucket"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "main.handler"
  runtime          = "python3.12"
  environment {
    variables = {
      GOOGLE_IDENTITY_PROVIDER = var.gcp_identity_provider
      GOOGLE_PROJECT_ID        = var.google_project_id
      GCS_BUCKET_NAME          = google_storage_bucket.this.name
    }
  }
  timeout = 60
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
}
