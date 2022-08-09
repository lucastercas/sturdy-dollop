resource "aws_iam_role" "codebuild" {
  name = "codebuild-app-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild_policy"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Effect : "Allow"
        Resource : ["*"]
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecs:RunTask",
          "iam:PassRole"
        ]
      },
      {
        Effect : "Allow"
        Action : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:List*",
          "s3:PutObject"
        ]
        Resource : ["${aws_s3_bucket.source.arn}", "${aws_s3_bucket.source.arn}/*"]
      }
    ]
  })
}

data "template_file" "build" {
  template = file("${path.module}/build.yml")
}

resource "aws_codebuild_project" "app" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "app-build"
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild.arn

  artifacts {
    encryption_disabled    = false
    name                   = "app-build-dev"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.build.rendered
  }

  tags = merge(var.tags, {})
}
