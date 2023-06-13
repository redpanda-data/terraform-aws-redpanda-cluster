resource "random_uuid" "cluster" {}

resource "time_static" "timestamp" {}

resource "aws_instance" "redpanda" {
  count                       = var.nodes
  ami                         = coalesce(var.cluster_ami, data.aws_ami.ami.image_id)
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh.key_name
  iam_instance_profile        = var.tiered_storage_enabled ? aws_iam_instance_profile.redpanda[0].name : null
  placement_group             = var.ha ? aws_placement_group.redpanda-pg[0].id : null
  placement_partition_number  = var.ha ? (count.index % aws_placement_group.redpanda-pg[0].partition_count) + 1 : null
  availability_zone           = var.availability_zone[count.index % length(var.availability_zone)]
  vpc_security_group_ids      = coalesce(var.security_groups_redpanda, [aws_security_group.node_sec_group.id])
  subnet_id                   = var.redpanda_subnet_id
  associate_public_ip_address = var.associate_public_ip_addr

  tags = merge(
    local.merged_tags,
    {
      Name = "${local.deployment_id}-node-${count.index}",
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

resource "aws_ebs_volume" "ebs_volume" {
  count             = var.nodes * var.ec2_ebs_volume_count
  availability_zone = aws_instance.redpanda[*].availability_zone[count.index]
  size              = var.ec2_ebs_volume_size
  type              = var.ec2_ebs_volume_type
  iops              = var.ec2_ebs_volume_iops
  throughput        = var.ec2_ebs_volume_throughput
}

resource "aws_volume_attachment" "volume_attachment" {
  count       = var.nodes * var.ec2_ebs_volume_count
  volume_id   = aws_ebs_volume.ebs_volume[*].id[count.index]
  device_name = var.ec2_ebs_device_names[count.index]
  instance_id = aws_instance.redpanda[*].id[count.index]
}

resource "aws_key_pair" "ssh" {
  key_name   = "${local.deployment_id}-key"
  public_key = file(var.public_key_path)
  tags       = local.merged_tags
}

resource "aws_placement_group" "redpanda-pg" {
  name            = "redpanda-pg"
  strategy        = "partition"
  partition_count = 3
  tags            = local.merged_tags
  count           = var.ha ? 1 : 0
}
