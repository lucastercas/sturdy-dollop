module "pipeline" {
  source = "./pipeline"

  tags = local.tags

  repo_user   = "lucastercas"
  repo_name   = "sturdy-dollop"
  repo_branch = "master"
}
