resource "aws_s3_bucket" "artifact" {
  bucket        = "${var.app_name}-artifact"
  force_destroy = true
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.app_name}-${var.environment}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = "${var.repo_user}/${var.repo_name}"
        BranchName       = var.repo_branch
      }
      output_artifacts = ["SourceArtifact"]
    }
  }

  stage {
    name = "Build"
    action {
      category = "Build"
      name     = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"
      configuration = {
        ProjectName = aws_codebuild_project.app.name
      }
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
    }
  }

  stage {
    name = "Deploy"
    action {
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      version         = "1"
      name            = "Deploy"
      input_artifacts = ["BuildArtifact"]
      configuration = {
        ApplicationName = var.ebs_application_name
        EnvironmentName = var.ebs_environment_name
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.app_name}-${var.environment}"
  })
}
