resource "aws_elastic_beanstalk_application" "app" {
  name = "app"
}

resource "aws_elastic_beanstalk_environment" "app_dev" {
  name                = "app-dev"
  description         = "App Dev Environment"
  application         = aws_elastic_beanstalk_application.app.name
  tier                = "WebServer"
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.app.name

  #===== Network =====#
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = module.network.vpc.id
  }
  #setting {
  #  namespace = "aws:ec2:vpc"
  #  name      = "AssociatePublicIpAddress"
  #  value     = true
  #}
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = module.network.subnets.public[0]
  }

  #setting {
  #  namespace = "aws:autoscaling:launchconfiguration"
  #  name      = "SecurityGroups"
  #  value     = 
  #}

  #===== Autoscaling =====#
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk.name
  }
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro"
  }

  tags = merge(local.tags, {})
}
