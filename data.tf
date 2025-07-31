# we extract the IAM username by getting the caller identity as an ARN
# then extracting the resource protion, which gives something like
# user/travis.downs, and finally we strip the user/ part to use as a tag
data "aws_caller_identity" "current" {}

data "aws_arn" "caller_arn" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_ami" "ami" {
  most_recent = true
  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*",
      "ubuntu/images/hvm-ssd/ubuntu-*-arm64-server-*",
      "Fedora-Cloud-Base-*.x86_64-hvm-${var.aws_region}-gp2-0",
      "Fedora-Cloud-Base-*.aarch64-hvm-${var.aws_region}-gp2-0",
      "Fedora-Cloud-Base-*.x86_64-hvm-${var.aws_region}-gp3-0",
      "Fedora-Cloud-Base-*.aarch64-hvm-${var.aws_region}-gp3-0",
      "Fedora-Cloud-Base-*.x86_64-hvm-${var.aws_region}-standard",
      "Fedora-Cloud-Base-*.aarch64-hvm-${var.aws_region}-standard",
      "debian-*-amd64-*",
      "debian-*-hvm-x86_64-gp2-*'",
      "amzn2-ami-hvm-2.0.*-x86_64-gp2",
      "RHEL*HVM-*-x86_64*Hourly2-GP2",
      "debian-*-hvm-x86_64-gp3-*'",
      "amzn2-ami-hvm-2.0.*-x86_64-gp3",
      "RHEL*HVM-*-x86_64*Hourly2-GP3"
    ]
  }
  filter {
    name   = "architecture"
    values = [var.machine_architecture]
  }
  filter {
    name   = "name"
    values = ["*${var.distro}*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477", "125523088429", "136693071363", "137112412989", "309956199498"]
  # Canonical, Fedora, Debian (new), Amazon, RedHat
}