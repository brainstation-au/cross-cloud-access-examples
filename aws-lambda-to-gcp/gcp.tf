resource "google_storage_bucket" "this" {
  name          = var.app_name
  location      = "AUSTRALIA-SOUTHEAST1"
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectAdmin"
  member = "principalSet://iam.googleapis.com/${var.gcp_identity_pool_for_aws}/attribute.aws_role/${aws_iam_role.this.name}"
}
