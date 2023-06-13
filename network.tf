resource "aws_security_group" "node_sec_group" {
  name        = "${local.deployment_id}-node-sec-group"
  tags        = local.merged_tags
  description = "redpanda ports"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = {for name, details in var.ingress_rules : name => details if details.enabled}
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      self            = ingress.value.self
      security_groups = ingress.value.security_groups
    }
  }
  dynamic "egress" {
    for_each = {for name, details in var.egress_rules : name => details if details.enabled}
    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      self            = egress.value.self
      security_groups = egress.value.security_groups
    }
  }
}

resource "aws_route53_record" "private_record" {
  count = var.create_r53_records ? var.nodes : 0

  zone_id = var.zone_id
  name    = random_id.redpanda[count.index].b64_url
  type    = "A"
  ttl     = "300"
  records = [aws_instance.redpanda[count.index].private_ip]
}