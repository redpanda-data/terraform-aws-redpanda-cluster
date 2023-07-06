resource "local_file" "hosts_ini" {
  content = templatefile("${path.module}/hosts.ini.tpl", {
    cloud_storage_region       = var.aws_region
    client_public_ips          = aws_instance.client[*].public_ip
    client_private_ips         = aws_instance.client[*].private_ip
    enable_monitoring          = var.enable_monitoring
    monitor_public_ip          = var.enable_monitoring ? aws_instance.prometheus[0].public_ip : ""
    monitor_private_ip         = var.enable_monitoring ? aws_instance.prometheus[0].private_ip : ""
    rack                       = var.ha ? aws_instance.broker[*].placement_partition_number : aws_instance.broker[*].availability_zone
    rack_awareness             = var.ha || length(var.availability_zone) > 1
    availability_zone          = aws_instance.broker[*].availability_zone
    redpanda_public_ips        = aws_instance.broker[*].public_ip
    redpanda_private_ips       = aws_instance.broker[*].private_ip
    ssh_user                   = var.distro_ssh_user[var.distro]
    tiered_storage_bucket_name = local.tiered_storage_bucket_name
    tiered_storage_enabled     = var.tiered_storage_enabled
  })
  filename = var.hosts_file
}
