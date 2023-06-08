module "simple-example" {
  source                   = "../../"
  clients                  = 1
  deployment_prefix        = "redpanda-simple"
  private_key_path         = ".ssh/id_rsa"
  associate_public_ip_addr = true
  tags                     = {
    "owner" : "simple-test"
  }
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