output "beanstalk" {
  value = {
    url : aws_elastic_beanstalk_environment.app_dev.cname
  }
}
