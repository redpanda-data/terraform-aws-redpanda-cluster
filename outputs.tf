output "broker" {
  description = "A map of public IPs to private IPs for the Broker instances."
  value = {
    for instance in aws_instance.broker :
    instance.public_ip => instance.private_ip...
  }
}

output "broker_id" {
  description = "A map with instance IDs of the Redpanda instances."
  value = {
    for instance in aws_instance.broker :
    "instance_id" => instance.id...
  }
}

resource "random_id" "broker" {
  count       = length(aws_instance.broker[*].id)
  byte_length = 5
  keepers = {
    instance_id = aws_instance.broker[count.index].id
  }
}

output "prometheus" {
  description = "A map of public IPs to private IPs for the Prometheus instances."
  value = {
    for instance in aws_instance.prometheus :
    instance.public_ip => instance.private_ip...
  }
}

resource "random_id" "prometheus" {
  count       = length(aws_instance.prometheus[*].id)
  byte_length = 5
  keepers = {
    instance_id = aws_instance.prometheus[count.index].id
  }
}

output "prometheus_id" {
  description = "A map with instance IDs of the Prometheus instances."
  value = {
    for instance in aws_instance.prometheus :
    "instance_id" => instance.id...
  }
}

output "connect" {
  description = "A map of public IPs to private IPs for the Connect instances."
  value = {
    for instance in aws_instance.connect :
    instance.public_ip => instance.private_ip...
  }
}

output "connect_id" {
  description = "A map with instance IDs of the Connect instances."
  value = {
    for instance in aws_instance.connect :
    "instance_id" => instance.id...
  }
}

resource "random_id" "connect" {
  count       = length(aws_instance.connect[*].id)
  byte_length = 5
  keepers = {
    instance_id = aws_instance.connect[count.index].id
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

resource "random_id" "client" {
  count       = length(aws_instance.client[*].id)
  byte_length = 5
  keepers = {
    instance_id = aws_instance.client[count.index].id
  }
}

output "ssh_user" {
  description = "SSH user name for the specified distribution."
  value       = var.distro_ssh_user[var.distro]
}

output "public_key_path" {
  description = "Path to the public SSH key."
  value       = var.public_key_path
}

output "node_details" {
  description = "Details of the nodes in the deployment."
  value       = local.node_details
}