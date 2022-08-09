resource "aws_iam_role" "beanstalk" {
  name = "app-beanstalk"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "BeanstalkAssumeRole"
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  inline_policy {
    name = "app-beanstalk"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid : "BucketAccess"
          Action : ["s3:Get*", "s3:List*", "s3:PutObject"]
          Effect : "Allow"
          Resource : ["arn:aws:s3:::elasticbeanstalk-*", "arn:aws:s3:::elasticbeanstalk-*/*"]
        },
        {
          Sid : "CloudWatchLogsAccess"
          Action : [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:DescribeLogGroups"
          ]
          Effect : "Allow"
          Resource : ["arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"]
        },
        {
          Sid : "ElasticBeanstalkHealthAccess"
          Action : ["elasticbeanstalk:PutInstanceStatistics"]
          Effect : "Allow"
          Resource : [
            "arn:aws:elasticbeanstalk:*:*:application/*",
            "arn:aws:elasticbeanstalk:*:*:environment/*"
          ]
        }
      ]
    })
  }
  tags = merge(local.tags, {
    Name = "app-beanstalk"
  })
}

resource "aws_iam_instance_profile" "beanstalk" {
  name = "app-beanstalk"
  path = "/"
  role = aws_iam_role.beanstalk.name
  tags = merge(local.tags, {
    Name = "app-beanstalk"
  })
}

data "aws_elastic_beanstalk_solution_stack" "app" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux 2 (.*) running Ruby 2.7$"
}

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
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = module.network.subnets.public[0]
  }

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
