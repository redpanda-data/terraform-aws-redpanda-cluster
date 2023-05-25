module "simple-example" {
  source = "../../"
  clients = 1
  deployment_prefix = "redpanda-simple"
  private_key_path = ".ssh/id_rsa"
  associate_public_ip_addr = true
  tags = {
    "owner" : "simple-test"
  }
}