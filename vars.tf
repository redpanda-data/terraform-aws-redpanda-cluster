variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the infrastructure on"
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "The AWS AZ to deploy the infrastructure on"
  default     = ["us-west-2a"]
  type        = list(string)
}

variable "clients" {
  description = "Number of client hosts"
  type        = number
  default     = 0
}

variable "client_distro" {
  type        = string
  description = "Linux distribution to use for clients."
  default     = "ubuntu-focal"
}

variable "client_instance_type" {
  type        = string
  description = "Default client instance type to create"
  default     = "m5n.2xlarge"
}

variable "deployment_prefix" {
  description = "The prefix for the instance name (defaults to {random uuid}-{timestamp})"
  type        = string
  default     = ""
}

variable "distro" {
  type        = string
  description = "The default distribution to base the cluster on"
  default     = "ubuntu-focal"
}

variable "enable_monitoring" {
  description = "Setup a prometheus/grafana instance"
  type        = bool
  default     = true
}

## It is important that device names do not get duplicated on hosts, in rare circumstances the choice of nodes * volumes can result in a factor that causes duplication. Modify this field so there is not a common factor.
## Please pr a more elegant solution if you have one.
variable "ec2_ebs_device_names" {
  type        = list(string)
  description = "Device names for EBS volumes"
  default     = [
    "/dev/xvdba",
    "/dev/xvdbb",
    "/dev/xvdbc",
    "/dev/xvdbd",
    "/dev/xvdbe",
    "/dev/xvdbf",
    "/dev/xvdbg",
    "/dev/xvdbh",
    "/dev/xvdbi",
    "/dev/xvdbj",
    "/dev/xvdbk",
    "/dev/xvdbl",
    "/dev/xvdbm",
    "/dev/xvdbn",
    "/dev/xvdbo",
    "/dev/xvdbp",
    "/dev/xvdbq",
    "/dev/xvdbr",
    "/dev/xvdbs",
    "/dev/xvdbt",
    "/dev/xvdbu",
    "/dev/xvdbv",
    "/dev/xvdbw",
    "/dev/xvdbx",
    "/dev/xvdby",
    "/dev/xvdbz"
  ]
}

variable "ec2_ebs_volume_count" {
  type        = number
  description = "Number of EBS volumes to attach to each Redpanda node"
  default     = 0
}

variable "ec2_ebs_volume_iops" {
  type        = number
  description = "IOPs for GP3 Volumes"
  default     = 16000
}

variable "ec2_ebs_volume_size" {
  type        = number
  description = "Size of each EBS volume"
  default     = 100
}

variable "ec2_ebs_volume_throughput" {
  type        = number
  description = "Throughput per volume in MiB"
  default     = 250
}

variable "ec2_ebs_volume_type" {
  type        = string
  description = "EBS Volume Type (gp3 recommended for performance)"
  default     = "gp3"
}

variable "ha" {
  description = "Whether to use placement groups to create an HA topology"
  type        = bool
  default     = false
}

variable "instance_type" {
  type        = string
  description = "Default redpanda instance type to create"
  default     = "i3.2xlarge"
}

variable "machine_architecture" {
  type        = string
  description = "Architecture used for selecting the AMI - change this if using ARM based instances"
  default     = "x86_64"
}

variable "nodes" {
  description = "The number of nodes to deploy"
  type        = number
  default     = "3"
}

variable "prometheus_instance_type" {
  type        = string
  description = "Instant type of the prometheus/grafana node"
  default     = "c5.2xlarge"
}

variable "cluster_ami" {
  type        = string
  description = "AMI for Redpanda broker nodes (if not set, will select based on the distro variable"
  default     = null
}

variable "prometheus_ami" {
  type        = string
  description = "AMI for prometheus nodes (if not set, will select based on the distro variable"
  default     = null
}

variable "client_ami" {
  type        = string
  description = "AMI for Redpanda client nodes (if not set, will select based on the distro variable"
  default     = null
}

variable "public_key_path" {
  type        = string
  description = "The public key used to ssh to the hosts"
  default     = "~/.ssh/id_rsa.pub"
}

variable "distro_ssh_user" {
  description = "The default user used by the AWS AMIs"
  type        = map(string)
  default     = {
    "debian-10"            = "admin"
    "debian-11"            = "admin"
    "Fedora-Cloud-Base-34" = "fedora"
    "Fedora-Cloud-Base-35" = "fedora"
    #"Fedora-Cloud-Base-36" = "fedora"
    #"Fedora-Cloud-Base-37" = "fedora"
    "ubuntu-bionic"        = "ubuntu"
    "ubuntu-focal"         = "ubuntu"
    "ubuntu-hirsute"       = "ubuntu"
    "ubuntu-jammy"         = "ubuntu"
    "ubuntu-kinetic"       = "ubuntu"
    "RHEL-8"               = "ec2-user"
    #"RHEL-9"              = "ec2-user"
    "amzn2"                = "ec2-user"
  }
}

variable "tiered_storage_enabled" {
  description = "Enables or disables tiered storage"
  type        = bool
  default     = false
}

variable "private_key_path" {
  type        = string
  description = "The contents of an SSH key to use for the connection. These can be loaded from a file on disk using the file function. This takes preference over password if provided."
  default     = null
}

variable "security_groups_client" {
  type        = list(string)
  description = "Any additional security groups to attach to the client nodes"
  default     = []
}

variable "security_groups_prometheus" {
  type        = list(string)
  description = "Any additional security groups to attach to the prometheus nodes"
  default     = []
}

variable "security_groups_redpanda" {
  type        = list(string)
  description = "Any additional security groups to attach to the Redpanda nodes"
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the EC2 instances will be deployed. An empty string will deploy to the default VPC. If provided, it must be in the same VPC as vpc_id"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "A map of key value pairs passed through to AWS tags on resources"
  nullable    = true
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to deploy the instances. If an ID is an empty string, the default VPC is used. If provided, the subnet_id must also be provided."
  default     = ""
}

variable "cloud_provider" {
  type        = string
  description = "the short, lower case form of the cloud provider"
  default     = "aws"
}

# allow_force_destroy is only intended for demos and CI testing and to support decommissioning a cluster entirely
# enabling it will result in loss of any data or topic info stored in the bucket
variable "allow_force_destroy" {
  default     = false
  type        = bool
  description = "DANGER: Enabling this option will delete your data in Tiered Storage when terraform destroy is run. Enable this only after careful consideration of the data loss consequences."
}

variable "associate_public_ip_addr" {
  default     = false
  type        = bool
  description = "Allows enabling public ips when using a custom VPC rather than the default"
}

variable "ingress_rules" {
  description = "Map of ingress rules to create"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    enabled     = bool
    cidr_block  = list(string)
    self        = bool
  }))
  default = {
    "SSH" = {
      description = "Allow inbound to ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      enabled     = true
      cidr_block  = ["0.0.0.0/0"]
      self        = null
    }
    "Kafka" = {
      description = "Allow anywhere inbound to access the Redpanda Kafka endpoint"
      from_port   = 9092
      to_port     = 9092
      protocol    = "tcp"
      enabled     = true
      cidr_block  = ["0.0.0.0/0"]
      self        = null
    }
    "RPC" = {
      description = "Allow security-group only to access Redpanda RPC endpoint for intra-cluster communication"
      from_port   = 33145
      to_port     = 33145
      protocol    = "tcp"
      enabled     = true
      cidr_block  = null
      self        = true
    }
    "Admin" = {
      description = "Allow anywhere inbound to access Redpanda Admin endpoint"
      from_port   = 9644
      to_port     = 9644
      protocol    = "tcp"
      enabled     = true
      cidr_block  = ["0.0.0.0/0"]
      self        = null
    }
    "Grafana" = {
      description = "Allow anywhere inbound to access grafana end point for monitoring"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      enabled     = true
      cidr_block  = ["0.0.0.0/0"]
      self        = null
    }
    "JavaOMB" = {
      description = "Allow anywhere inbound to access for Open Messaging Benchmark"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      enabled     = true
      cidr_block  = ["0.0.0.0/0"]
      self        = null
    }
    "Prometheus" = {
      description = "Allow anywhere inbound to access Prometheus end point for monitoring"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      enabled     = true
      cidr_block  = ["0.0.0.0/0"]
      self        = null
    }
    "NodeExporter" = {
      description = "node_exporter access within the security-group for ansible"
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      enabled     = true
      cidr_block  = null
      self        = true
    }
  }
}

variable "egress_rules" {
  description = "Map of egress rules to create"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    enabled     = bool
    cidr_blocks = list(string)
    self        = bool
  }))
  default = {
    "InternetAccess" = {
      description = "Allow all outbound Internet access"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      enabled     = true
      self        = null
    }
  }
}

variable "hosts_file" {
  default = "hosts.ini"
  description = "path and name for ansible hosts file generated as output of this module"
  type = string
}