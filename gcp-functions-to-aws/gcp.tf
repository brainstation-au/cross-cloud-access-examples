resource "google_service_account" "this" {
  account_id   = local.app_name
  display_name = "GCP FN to AWS"
  project      = var.google_project_id
}

resource "google_storage_bucket" "this" {
  name                        = local.app_name
  location                    = var.google_cloud_region
  force_destroy               = true
  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.module}/tmp/functions.zip"
  source_dir  = "${path.module}/functions"
}

resource "google_storage_bucket_object" "this" {
  name   = data.archive_file.this.id
  source = data.archive_file.this.output_path
  bucket = google_storage_bucket.this.name
}

resource "google_cloudfunctions2_function" "this" {
  name        = local.app_name
  location    = var.google_cloud_region
  description = "GCP FN to AWS"

  build_config {
    runtime     = "python311"
    entry_point = "hello_http"
    source {
      storage_source {
        bucket = google_storage_bucket.this.name
        object = google_storage_bucket_object.this.name
      }
    }
  }

  service_config {
    max_instance_count    = 1
    available_memory      = "256M"
    timeout_seconds       = 60
    service_account_email = google_service_account.this.email
    environment_variables = {
      AWS_DEFAULT_REGION    = var.aws_region
      AWS_ROLE_ARN          = aws_iam_role.this.arn
      AWS_ROLE_SESSION_NAME = local.app_name
      S3_BUCKET_NAME        = aws_s3_bucket.this.id
    }
  }
}
