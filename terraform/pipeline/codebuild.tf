resource "aws_codebuild_project" "app" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "${var.app_name}-${var.environment}-build"
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild.arn

  artifacts {
    encryption_disabled    = false
    name                   = "${var.app_name}-${var.environment}-.zip"
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
    type = "CODEPIPELINE"
    buildspec = templatefile("${path.module}/build.yml", {
      env = "dev"
    })
  }

  tags = merge(var.tags, {
    Name = "${var.app_name}-${var.environment}"
  })
}
