output "beanstalk" {
  value = {
    url : aws_elastic_beanstalk_environment.app.cname
  }
}

output "subnets" {
  value = module.network.subnets
}

output "webhook_url" {
  value = module.pipeline_dev.webhook_url
}
