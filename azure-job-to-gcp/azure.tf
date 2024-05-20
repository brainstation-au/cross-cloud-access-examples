resource "azurerm_log_analytics_workspace" "this" {
  name                = local.app_name
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  name                       = local.app_name
  location                   = var.azure_resource_group_location
  resource_group_name        = var.azure_resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}

resource "azurerm_container_app_job" "this" {
  name                         = local.app_name
  location                     = var.azure_resource_group_location
  resource_group_name          = var.azure_resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id

  replica_timeout_in_seconds = 60
  replica_retry_limit        = 1

  identity {
    type = "SystemAssigned"
  }

  manual_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
  }

  template {
    container {
      image  = "${local.image_name}@${docker_registry_image.this.sha256_digest}"
      name   = local.app_name
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "GCP_IDENTITY_PROVIDER"
        value = var.gcp_identity_provider
      }
      env {
        name  = "GOOGLE_PROJECT_ID"
        value = var.google_project_id
      }
      env {
        name  = "GCS_BUCKET_NAME"
        value = google_storage_bucket.this.name
      }
    }
  }
}
