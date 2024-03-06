resource "aws_instance" "connect" {
  count                       = var.enable_connect ? var.connect_count * length(var.availability_zone) : 0
  ami                         = coalesce(var.connect_ami, data.aws_ami.ami.image_id)
  instance_type               = var.connect_instance_type
  key_name                    = aws_key_pair.ssh.key_name
  subnet_id                   = try(lookup(local.merged_subnets["connect"], var.availability_zone[count.index % length(var.availability_zone)]), "")
  vpc_security_group_ids      = coalesce(var.security_groups_connect, [aws_security_group.node_sec_group.id])
  associate_public_ip_address = var.associate_public_ip_addr

  tags = merge(
    local.merged_tags,
    {
      Name = "${local.deployment_id}-connect",
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

