resource "null_resource" "app-deploy" {
  count       = length(local.PRIVATE_IPS)
  triggers = {
    private_ip = element(local.PRIVATE_IPS, count.index)
  }
  provisioner "remote_exec" {
    connection {
      host     = element(local.PRIVATE_IPS, count.index)
      user     = local.SSH_user
      password = local.SSH_pass
    }

    inline = [
      "ansible-pull -U https://github.com/rayuduroyal/ansible.git roboshop-pull.yaml -e ENV=${var.ENV} -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USER=${var.NEXUS_USER} -e NEXUS_PASS=${var.NEXUS_PASS}"
    ]
  }
}