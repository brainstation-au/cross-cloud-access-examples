resource "aws_s3_bucket" "this" {
  bucket        = local.app_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]
  bucket     = aws_s3_bucket.this.id
  acl        = "private"
}

resource "aws_iam_role" "this" {
  name = local.app_name
  path = local.aws_iam_role_path
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "accounts.google.com"
        }
        Condition = {
          StringEquals = {
            "accounts.google.com:aud" = google_service_account.this.unique_id
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  name = "s3-access"
  role = aws_iam_role.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = aws_s3_bucket.this.arn
      },
      {
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.this.arn}/*"
      },
    ]
  })
}
