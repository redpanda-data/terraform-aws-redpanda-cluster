resource "aws_instance" "client" {
  count                       = var.client_count
  ami = coalesce(var.client_ami, data.aws_ami.ami.image_id)
  instance_type               = var.client_instance_type
  key_name                    = aws_key_pair.ssh.key_name
  subnet_id = try(lookup(local.merged_subnets["client"], var.availability_zone[count.index % length(var.availability_zone)]), "")
  vpc_security_group_ids = coalesce(var.security_groups_client, [aws_security_group.node_sec_group.id])
  associate_public_ip_address = var.associate_public_ip_addr_client

  tags = merge(
    local.merged_tags,
    {
      Name = "${local.deployment_id}-client",
    }
  )

  lifecycle {
    ignore_changes = [ami]
  }
}
