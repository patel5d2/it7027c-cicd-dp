terraform {
  required_version = ">= 1.6.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Uses the Docker daemon available on the GitHub Actions runner
provider "docker" {}

variable "container_name" {
  description = "Name of the web container"
  type        = string
  default     = "it7027c-web"
}

variable "external_port" {
  description = "Host port mapped to nginx port 80"
  type        = number
  default     = 8080
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_container" "web" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.external_port
  }
}

output "container_id" {
  value = docker_container.web.id
}

output "web_url" {
  value = "http://localhost:${var.external_port}"
}
