module "tiered-example" {
  source = "../../"
  clients = 1
  deployment_prefix = "redpanda-tiered"
  tiered_storage_enabled = true
  allow_force_destroy = true
  private_key_path = ".ssh/id_rsa"
  associate_public_ip_addr = true
  tags = {
    "owner" : "tiered-test"
  }
}