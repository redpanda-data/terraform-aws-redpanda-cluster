# terraform-aws-redpanda-cluster

[![Build status](https://badge.buildkite.com/474f20b5cae84a6213f822e1643d24e76a38d37229e461421b.svg)](https://buildkite.com/redpanda/terraform-aws-redpanda-cluster)

This Terraform module will deploy VMs on AWS EC2, with a security group which allows inbound traffic on ports used by
Redpanda and monitoring tools. Once deployed, you can
use [our Ansible collection](https://github.com/redpanda-data/redpanda-ansible-collection) to build
a [Redpanda Cluster](https://docs.redpanda.com/docs/home/).

## Requirements

| Name   | Version |
|--------|---------|
| aws    | 4.35.0  |
| local  | 2.1.0   |
| random | 3.1.0   |

## Providers

| Name   | Version |
|--------|---------|
| aws    | 4.35.0  |
| local  | 2.1.0   |
| random | 3.1.0   |

## Variables

| Variable Name              | Variable Type | Variable Description                                                                                                                                                                                                        |
|----------------------------|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| aws_region                 | string        | The AWS region to deploy the infrastructure on                                                                                                                                                                              |
| availability_zone          | list(string)  | The AWS AZ to deploy the infrastructure on                                                                                                                                                                                  |
| clients                    | number        | Number of client hosts                                                                                                                                                                                                      |
| client_distro              | string        | Linux distribution to use for clients                                                                                                                                                                                       |
| client_instance_type       | string        | Default client instance type to create                                                                                                                                                                                      |
| deployment_prefix          | string        | The prefix for the instance name (defaults to {random uuid}-{timestamp})                                                                                                                                                    |
| distro                     | string        | The default distribution to base the cluster on                                                                                                                                                                             |
| enable_monitoring          | bool          | Setup a prometheus/grafana instance                                                                                                                                                                                         |
| ec2_ebs_device_names       | list(string)  | Device names for EBS volumes                                                                                                                                                                                                |
| ec2_ebs_volume_count       | number        | Number of EBS volumes to attach to each Redpanda node                                                                                                                                                                       |
| ec2_ebs_volume_iops        | number        | IOPs for GP3 Volumes                                                                                                                                                                                                        |
| ec2_ebs_volume_size        | number        | Size of each EBS volume                                                                                                                                                                                                     |
| ec2_ebs_volume_throughput  | number        | Throughput per volume in MiB                                                                                                                                                                                                |
| ec2_ebs_volume_type        | string        | EBS Volume Type (gp3 recommended for performance)                                                                                                                                                                           |
| ha                         | bool          | Whether to use placement groups to create an HA topology                                                                                                                                                                    |
| instance_type              | string        | Default redpanda instance type to create                                                                                                                                                                                    |
| machine_architecture       | string        | Architecture used for selecting the AMI - change this if using ARM based instances                                                                                                                                          |
| nodes                      | number        | The number of nodes to deploy                                                                                                                                                                                               |
| prometheus_instance_type   | string        | Instant type of the prometheus/grafana node                                                                                                                                                                                 |
| cluster_ami                | string        | AMI for Redpanda broker nodes (if not set, will select based on the distro variable                                                                                                                                         |
| prometheus_ami             | string        | AMI for prometheus nodes (if not set, will select based on the distro variable                                                                                                                                              |
| client_ami                 | string        | AMI for Redpanda client nodes (if not set, will select based on the distro variable                                                                                                                                         |
| public_key_path            | string        | The public key used to ssh to the hosts                                                                                                                                                                                     |
| distro_ssh_user            | map(string)   | The default user used by the AWS AMIs                                                                                                                                                                                       |
| tiered_storage_enabled     | bool          | Enables or disables tiered storage                                                                                                                                                                                          |
| private_key_path           | string        | The contents of an SSH key to use for the connection. These can be loaded from a file on disk using the file function. This takes preference over password if provided.                                                     |
| security_groups_client     | list(string)  | Any additional security groups to attach to the client nodes                                                                                                                                                                |
| security_groups_prometheus | list(string)  | Any additional security groups to attach to the prometheus nodes                                                                                                                                                            |
| security_groups_redpanda   | list(string)  | Any additional security groups to attach to the Redpanda nodes                                                                                                                                                              |
| subnet_id                  | string        | The ID of the subnet where the EC2 instances will be deployed. An empty string will deploy to the default VPC. If provided, it must be in the same VPC as vpc_id                                                            |
| tags                       | map(string)   | A map of key value pairs passed through to AWS tags on resources                                                                                                                                                            |
| vpc_id                     | string        | The ID of the VPC to deploy the instances. If an ID is an empty string, the default VPC is used. If provided, the subnet_id must also be provided.                                                                          |
| cloud_provider             | string        | the short, lower case form of the cloud provider                                                                                                                                                                            |
| allow_force_destroy        | bool          | DANGER: Enabling this option will delete your data in Tiered Storage when terraform destroy is run.                                                                                                                         
| associate_public_ip_addr   | bool          | Allows enabling public IPs when using a custom VPC rather than the default                                                                                                                                                  |
| ingress_rules              | map(object)   | Map of ingress rules to create. Each rule has the following properties: `description` (string), `from_port` (number), `to_port` (number), `protocol` (string), `enabled` (bool), `cidr_block` (list(string)), `self` (bool) |
| egress_rules               | map(object)   | Map of egress rules to create. Each rule has the following properties: `description` (string), `from_port` (number), `to_port` (number), `protocol` (string), `enabled` (bool), `cidr_blocks` (list(string)), `self` (bool) |
| hosts_file_path            | string        | Path to the desired location of the Ansible hosts file, must NOT have trailing /                                                                                                                                            |
| hosts_file_name            | string        | Name of the Ansible hosts file                                                                                                                                                                                              |

## Outputs

| Output Name     | Output Description                                               |
|-----------------|------------------------------------------------------------------|
| redpanda        | A map of public IPs to private IPs for the Redpanda instances.   |
| redpanda_id     | A map with instance IDs of the Redpanda instances.               |
| prometheus      | A map of public IPs to private IPs for the Prometheus instances. |
| prometheus_id   | A map with instance IDs of the Prometheus instances.             |
| client          | A map of public IPs to private IPs for the client instances.     |
| client_id       | A map with instance IDs of the client instances.                 |
| ssh_user        | SSH user name for the specified distribution.                    |
| public_key_path | Path to the public SSH key.                                      |
| node_details    | Details of the nodes in the deployment.                          |

## Examples

Examples can be found in the examples directory.

## Test

## Requirements

You must have Go installed in order to run infrastructure tests.

| Name      | Version |
|-----------|---------|
| go        | >1.18   |
| terraform | >1.0.0  |

Test the infrastructure with the following command:

`cd tests/ && go test `