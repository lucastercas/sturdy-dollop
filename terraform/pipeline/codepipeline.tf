resource "aws_codestarconnections_connection" "github" {
  provider_type = "GitHub"
  name          = "app-connection"

}
resource "aws_s3_bucket" "source" {
  bucket        = "app-pipeline"
  force_destroy = true
}

resource "aws_codepipeline" "pipeline" {
  name     = "app-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.source.bucket
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
        ConnectionArn    = aws_codestarconnections_connection.github.arn
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
        ProjectName = "app-build"
      }
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
    }
  }

  tags = merge(var.tags, {})
}
