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
