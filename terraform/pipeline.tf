module "pipeline_dev" {
  source = "./pipeline"

  tags        = local.tags
  environment = "dev"
  app_name    = local.app_name

  repo_user   = "lucastercas"
  repo_name   = "sturdy-dollop"
  repo_branch = "master"

  ebs_application_name = aws_elastic_beanstalk_application.app.name
  ebs_environment_name = aws_elastic_beanstalk_environment.app.name
  ebs_arn              = aws_elastic_beanstalk_application.app.arn

  codestar_connection_arn = aws_codestarconnections_connection.github.arn
}
