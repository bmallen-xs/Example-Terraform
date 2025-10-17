resource "null_resource" "bar" {
  # Changes to any instance of the cluster requires re-provisioning
  # count = 1
  triggers = {
    "name" = var.name
  }
}

module "foo_mod" {
  source = "../mod2"

  count = 1
}

variable "name" {
  default = "asdf"
}

output "bar" {
  value = null_resource.bar.id
}