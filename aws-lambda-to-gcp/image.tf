locals {
  image_registry = substr(data.aws_ecr_authorization_token.this.proxy_endpoint, 8, -1)
  image_name     = "${local.image_registry}/${aws_ecr_repository.this.name}"
  image_uri      = "${local.image_name}:latest"
}

resource "docker_image" "this" {
  name = local.image_uri
  build {
    context    = "${path.module}/lambda"
    cache_from = [local.image_uri]
  }
  platform = "linux/arm64"
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
