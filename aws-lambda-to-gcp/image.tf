locals {
  docker_context        = "${path.module}/lambda"
  docker_context_sha256 = sha256(join("", [for f in fileset(".", "${local.docker_context}/**") : file(f)]))
  image_registry        = substr(data.aws_ecr_authorization_token.this.proxy_endpoint, 8, -1)
  image_uri             = "${local.image_registry}/${aws_ecr_repository.this.name}"
  latest_image_uri      = "${local.image_uri}:latest"
  unique_image_uri      = "${local.image_uri}:${local.docker_context_sha256}"
}

resource "docker_image" "this" {
  name = local.image_uri
  build {
    context    = local.docker_context
    cache_from = [local.latest_image_uri]
    tag = [
      local.latest_image_uri,
      local.unique_image_uri,
    ]
  }
  platform = "linux/arm64"
}

resource "docker_registry_image" "unique" {
  name = local.unique_image_uri
  triggers = {
    content = local.docker_context_sha256
  }
  depends_on = [
    docker_image.this
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "docker_registry_image" "latest" {
  name = local.latest_image_uri
  triggers = {
    content = local.docker_context_sha256
  }
  depends_on = [
    docker_registry_image.unique
  ]
  lifecycle {
    create_before_destroy = true
  }
}
