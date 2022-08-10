module "pipeline" {
  source = "./pipeline"

  tags = local.tags

  repo_user   = "lucastercas"
  repo_name   = "sturdy-dollop"
  repo_branch = "master"

  ebs_application_name = aws_elastic_beanstalk_application.app.name
  ebs_environment_name = aws_elastic_beanstalk_environment.app_dev.name
  ebs_arn              = aws_elastic_beanstalk_application.app.arn
}
