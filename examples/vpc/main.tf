resource "aws_vpc" "test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}


resource "aws_route53_zone" "test" {
  name = "devextest.local"
  vpc {
    vpc_id = aws_vpc.test.id
  }
  tags = var.tags
}


resource "aws_subnet" "test" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.1.0/24"

  tags = var.tags
  availability_zone = "us-west-2a"
}

resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id

  tags = var.tags
}

resource "aws_route_table" "test" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "test" {
  subnet_id      = aws_subnet.test.id
  route_table_id = aws_route_table.test.id
}

module "redpanda-cluster" {
  source                   = "../../"
  public_key_path        = var.public_key_path
  nodes                  = var.nodes
  deployment_prefix      = var.deployment_prefix
  enable_monitoring      = var.enable_monitoring
  tiered_storage_enabled = var.tiered_storage_enabled
  allow_force_destroy    = var.allow_force_destroy
  vpc_id                 = aws_vpc.test.id
  distro                 = var.distro
  hosts_file             = var.hosts_file
  tags                   = var.tags
  subnet_id = aws_subnet.test.id
  availability_zone = ["us-west-2a"]
}


resource "aws_route53_record" "private_record" {
  count = var.nodes

  zone_id = aws_route53_zone.test.zone_id
  name    = "${element(keys(module.redpanda-cluster.redpanda_map), count.index)}.local"
  type    = "A"
  ttl     = "300"
  records = [element(values(module.redpanda-cluster.redpanda_map), count.index)]
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
  default = "test-rp-cluster"
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

output "test" {
  value = module.redpanda-cluster.redpanda_map
}