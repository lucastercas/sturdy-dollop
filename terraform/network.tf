module "network" {
  source             = "./network"
  tags               = merge(local.tags, {})
  availability_zones = ["us-west-2a"]
}
