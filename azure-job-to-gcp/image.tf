locals {
  image_registry = "registry.hub.docker.com"
  image_name     = "${var.docker_hub_username}/azure-job-to-gcp"
  image_uri      = "${local.image_registry}/${local.image_name}:latest"
}

resource "docker_image" "this" {
  name = local.image_uri
  build {
    context    = "${path.module}/job"
    cache_from = [local.image_uri]
  }
  platform = "linux/amd64"
  triggers = {
    uuid = uuid()
  }
}

resource "docker_registry_image" "this" {
  name = docker_image.this.name
  triggers = {
    content = docker_image.this.image_id
  }
}
