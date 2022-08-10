output "beanstalk" {
  value = {
    url : aws_elastic_beanstalk_environment.app_dev.cname
  }
}

output "subnets" {
  value = module.network.subnets
}
