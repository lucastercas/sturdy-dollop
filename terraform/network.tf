module "network" {
  source             = "./network"
  tags               = merge(local.tags, {})
  app_name           = local.app_name
  availability_zones = ["us-west-2a", "us-west-2b"]
}
