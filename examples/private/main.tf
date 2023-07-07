resource "aws_security_group" "client_sec_group" {
  name        = "${var.deployment_prefix}-client-sg"
  description = "client security group"
  vpc_id      = var.vpc_id
  tags        = var.tags

  ingress {
    description = "Allow outbound to ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "redpanda-cluster" {
  source                          = "../../"
  public_key_path                 = var.public_key_path
  broker_count                    = var.nodes
  deployment_prefix               = var.deployment_prefix
  enable_monitoring               = var.enable_monitoring
  tiered_storage_enabled          = var.tiered_storage_enabled
  allow_force_destroy             = var.allow_force_destroy
  distro                          = var.distro
  hosts_file                      = var.hosts_file
  tags                            = var.tags
  client_count                    = 1
  security_groups_client          = [aws_security_group.client_sec_group.id]
  associate_public_ip_addr        = true
  associate_public_ip_addr_client = true
  availability_zone               = ["us-west-2a"]
  egress_rules                    = {
    "SSH" = {
      description     = "Allow outbound to ssh"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = ["0.0.0.0/0"]
      self            = null
      security_groups = [aws_security_group.client_sec_group.id]
    }
  }
  ingress_rules = {
    "SSH" = {
      description     = "Allow inbound to ssh"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = ["0.0.0.0/0"]
      self            = null
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "Kafka" = {
      description     = "Allow inbound to access the Redpanda Kafka endpoint"
      from_port       = 9092
      to_port         = 9092
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "RPC" = {
      description     = "Allow security-group only to access Redpanda RPC endpoint for intra-cluster communication"
      from_port       = 33145
      to_port         = 33145
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "Admin" = {
      description     = "Allow inbound to access Redpanda Admin endpoint"
      from_port       = 9644
      to_port         = 9644
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "Grafana" = {
      description     = "Allow inbound to access grafana end point for monitoring"
      from_port       = 3000
      to_port         = 3000
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "JavaOMB" = {
      description     = "Allow inbound to access for Open Messaging Benchmark"
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "Prometheus" = {
      description     = "Allow inbound to access Prometheus end point for monitoring"
      from_port       = 9090
      to_port         = 9090
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "NodeExporter" = {
      description     = "node_exporter access within the security-group for ansible"
      from_port       = 9100
      to_port         = 9100
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
    "SchemaRegistry" = {
      description     = "schema_registry access for external users"
      from_port       = 8081
      to_port         = 8081
      protocol        = "tcp"
      enabled         = true
      cidr_blocks     = null
      self            = true
      security_groups = [aws_security_group.client_sec_group.id]
    }
  }
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "nodes" {
  type    = number
  default = 3
}

variable "deployment_prefix" {
  type    = string
  default = "rp-private"
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

variable "tiered_storage_enabled" {
  type    = bool
  default = false
}

variable "allow_force_destroy" {
  type    = bool
  default = false
}
variable "vpc_id" {
  description = "only set when you are planning to provide your own network rather than using the default one"
  type        = string
  default     = ""
}

variable "distro" {
  type    = string
  default = "ubuntu-focal"
}

variable "hosts_file" {
  type    = string
  default = "hosts.ini"
}

variable "tags" {
  type    = map(string)
  default = {}
}

terraform {
  required_version = ">=0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

variable "region" {
  type    = string
  default = "us-west-2"
}

provider "aws" {
  region = var.region
}
