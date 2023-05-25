resource "aws_instance" "prometheus" {
  count                       = var.enable_monitoring ? 1 : 0
  ami                         = coalesce(var.prometheus_ami, data.aws_ami.ami.image_id)
  instance_type               = var.prometheus_instance_type
  key_name                    = aws_key_pair.ssh.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = concat([aws_security_group.node_sec_group.id], var.security_groups_prometheus)
  associate_public_ip_address = var.associate_public_ip_addr

  tags = merge(
    local.merged_tags,
    {
      Name = "${local.deployment_id}-prometheus",
    }
  )

  connection {
    user        = var.distro_ssh_user[var.distro]
    host        = self.public_ip
    private_key = file(var.private_key_path)
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

