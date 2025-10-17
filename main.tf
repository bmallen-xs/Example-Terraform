resource "null_resource" "foo" {
  # Changes to any instance of the cluster requires re-provisioning
  count = 2
  depends_on = [ null_resource.bar ]
}

resource "null_resource" "bar" {
  triggers = {
    foo = random_pet.pet.id
  }
}

resource "random_pet" "pet" {}
resource "random_pet" "pets" {
  count = 5
}

resource "random_string" "random" {
  length           = 24
  special          = true
  min_lower = 2
  min_upper = 2
  min_numeric = 2
  min_special = 2
  # override_special = "/@£$"
}

module "bar_mod" {
  source = "./mod"

  count = 2
  name = random_pet.pet.id
}

output "bar_mod" {
  value = module.bar_mod.*.bar
}

output "bar" {
  value = null_resource.bar.id
}

output "pet" {
  value = random_pet.pet.id
}

output "pets" {
  value = random_pet.pets.*.id
}

output "random_string" {
  value = random_string.random.result
}

# Specify the Docker provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    keycloak = {
      source = "keycloak/keycloak"
    }
  }
}

# provider "keycloak" {
#     client_id     = "admin-cli"
#     username      = "keycloak"
#     password      = "password"
#     url           = "http://localhost:8080"
# }

# provider "kubernetes" {
#   # config_path    = "~/.kube/config"
#   # config_context = "my-context"
# }

# provider "helm" {}
# provider "aws" {
#   region = "us-east-1" # Specify your desired AWS region
# }

# provider "google" {}


# # Define the Docker image
# resource "docker_image" "nginx_image" {
#   name         = "nginx:latest"
#   keep_locally = false # Keep the image locally after creation
# }

# resource "docker_image" "ubuntu_image" {
#   name         = "ubuntu:24.04"
#   keep_locally = false # Keep the image locally after creation
# }

# # Define the Docker container
# resource "docker_container" "nginx_container" {
#   name  = "my-nginx-container"
#   image = docker_image.nginx_image.name

#   ports {
#     internal = 80
#     external = 80
#   }

#   # Optional: Mount a volume for NGINX configuration
#   # volumes {
#   #   container_path = "/etc/nginx/conf.d"
#   #   host_path      = "/path/to/your/nginx/conf"
#   # }
# }

# Output the container ID
# output "container_id" {
#   value       = docker_container.nginx_container.id
#   description = "The ID of the NGINX Docker container."
# }

resource "tls_private_key" "example_rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 2048 # Or 4096, etc.
}

resource "tls_cert_request" "example" {
  private_key_pem = tls_private_key.example_rsa_key.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "example" {
  cert_request_pem   = tls_cert_request.example.cert_request_pem
  ca_private_key_pem = tls_private_key.example_rsa_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.example.cert_pem

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_self_signed_cert" "example" {
  private_key_pem = tls_private_key.example_rsa_key.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
