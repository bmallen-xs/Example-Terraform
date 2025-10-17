resource "null_resource" "foo" {
  # Changes to any instance of the cluster requires re-provisioning
  count = 1
}
