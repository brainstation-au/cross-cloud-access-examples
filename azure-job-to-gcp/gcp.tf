resource "google_storage_bucket" "this" {
  name                        = local.app_name
  location                    = "AUSTRALIA-SOUTHEAST1"
  force_destroy               = true
  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectAdmin"
  member = "principal://iam.googleapis.com/${var.gcp_identity_pool}/subject/${one(azurerm_container_app_job.this.identity[*].principal_id)}"
}
