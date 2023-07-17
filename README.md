# terraform-aws-redpanda-cluster

[![Build status](https://badge.buildkite.com/474f20b5cae84a6213f822e1643d24e76a38d37229e461421b.svg)](https://buildkite.com/redpanda/terraform-aws-redpanda-cluster)

This [Terraform module](https://registry.terraform.io/modules/redpanda-data/redpanda-cluster/aws/latest) will deploy VMs
on AWS EC2, with a security group which allows inbound traffic on ports used by
Redpanda and monitoring tools. Once deployed, you can
use [our Ansible collection](https://github.com/redpanda-data/redpanda-ansible-collection) to build
a [Redpanda Cluster](https://docs.redpanda.com/docs/home/).

More information about building a Redpanda cluster can be viewed on
our [docs page](https://docs.redpanda.com/docs/deploy/deployment-option/self-hosted/manual/).

## Examples

Examples can be found in the examples directory.

## Test

Testing is done by running terraform apply in each of the example directories and verifying that a green apply has
occurred. In addition
the [deployment-automation](https://github.com/redpanda-data/deployment-automation) repo uses this module to build
Redpanda clusters.
