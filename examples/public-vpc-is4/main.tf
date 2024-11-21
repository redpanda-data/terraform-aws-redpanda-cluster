resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  tags       = var.tags
}

resource "aws_subnet" "server-a" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.1.0/24"

  tags              = var.tags
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "server-b" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.2.0/24"

  tags              = var.tags
  availability_zone = "us-west-2b"
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

resource "aws_route_table_association" "test-a" {
  subnet_id      = aws_subnet.server-a.id
  route_table_id = aws_route_table.test.id
}

resource "aws_route_table_association" "test-b" {
  subnet_id      = aws_subnet.server-b.id
  route_table_id = aws_route_table.test.id
}

module "redpanda-cluster" {
  source                 = "../../"
  public_key_path        = var.public_key_path
  broker_count           = var.nodes
  enable_monitoring      = var.enable_monitoring
  tiered_storage_enabled = var.tiered_storage_enabled
  allow_force_destroy    = var.allow_force_destroy
  aws_region             = var.region
  vpc_id                 = aws_vpc.test.id
  distro                 = var.distro
  hosts_file             = var.hosts_file
  tags                   = var.tags
  subnets = {
    broker = {
      "us-west-2a" = aws_subnet.server-a.id
      "us-west-2b" = aws_subnet.server-b.id
    }
  }
  availability_zone = ["us-west-2a", "us-west-2b"]
  deployment_prefix        = var.deployment_prefix
  associate_public_ip_addr = true
  machine_architecture     = "arm64"
  broker_instance_type     = "is4gen.4xlarge"
  client_instance_type     = "is4gen.4xlarge"
  prometheus_instance_type = "is4gen.4xlarge"
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
  default = "rp-public-vpc"
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

variable "distro" {
  type    = string
  default = "Fedora-Cloud-Base-39"
}

variable "hosts_file" {
  type    = string
  default = "hosts.ini"
}

variable "tags" {
  type = map(string)
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