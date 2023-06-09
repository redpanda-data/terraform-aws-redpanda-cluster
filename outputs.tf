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

resource "random_id" "redpanda" {
  count       = length(aws_instance.redpanda[*].id)
  byte_length = 5
  keepers     = {
    instance_id = aws_instance.redpanda[count.index].id
  }
}

output "redpanda_map" {
  value = { for i in range(length(aws_instance.redpanda[*].id)) :
    lower(random_id.redpanda[i].b64_url) => aws_instance.redpanda[i].private_ip
  }
  description = "A map of random IDs to public IPs for the Redpanda instances."
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
  keepers     = {
    instance_id = aws_instance.prometheus[count.index].id
  }
}

output "prometheus_map" {
  value = { for i in range(length(aws_instance.prometheus[*].id)) :
    lower(random_id.prometheus[i].b64_url) => aws_instance.prometheus[i].public_ip
  }
  description = "A map of random IDs to public IPs for the Prometheus instances."
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

resource "random_id" "client" {
  count       = length(aws_instance.client[*].id)
  byte_length = 5
  keepers     = {
    instance_id = aws_instance.client[count.index].id
  }
}

output "client_map" {
  value = { for i in range(length(aws_instance.client[*].id)) :
    lower(random_id.client[i].b64_url) => aws_instance.client[i].public_ip
  }
  description = "A map of random IDs to public IPs for the Client instances."
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