output "redpanda" {
  description = "A map of public IPs to private IPs for the Redpanda instances."
  value = {
    for instance in aws_instance.redpanda :
    instance.public_ip => instance.private_ip...
  }
}

output "redpanda_id" {
  description = "A map with instance IDs of the Redpanda instances."
  value = {
    for instance in aws_instance.redpanda :
    "instance_id" => instance.id...
  }
}

output "prometheus" {
  description = "A map of public IPs to private IPs for the Prometheus instances."
  value = {
    for instance in aws_instance.prometheus :
    instance.public_ip => instance.private_ip...
  }
}

output "prometheus_id" {
  description = "A map with instance IDs of the Prometheus instances."
  value = {
    for instance in aws_instance.prometheus :
    "instance_id" => instance.id...
  }
}

output "client" {
  description = "A map of public IPs to private IPs for the client instances."
  value = {
    for instance in aws_instance.client :
    instance.public_ip => instance.private_ip...
  }
}

output "client_id" {
  description = "A map with instance IDs of the client instances."
  value = {
    for instance in aws_instance.client :
    "instance_id" => instance.id...
  }
}

output "ssh_user" {
  description = "SSH user name for the specified distribution."
  value = var.distro_ssh_user[var.distro]
}

output "public_key_path" {
  description = "Path to the public SSH key."
  value = var.public_key_path
}

output "node_details" {
  description = "Details of the nodes in the deployment."
  value = local.node_details
}