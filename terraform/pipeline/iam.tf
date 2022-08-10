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
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = ["*"]
        Action = [
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
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:List*",
          "s3:PutObject"
        ]
        Resource = [aws_s3_bucket.source.arn, "${aws_s3_bucket.source.arn}/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["*"]
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role" "codepipeline" {
  name = "pipeline-app-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Effect : "Allow"
        Action : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ]
        Resource : ["${aws_s3_bucket.source.arn}", "${aws_s3_bucket.source.arn}/*"]
      },
      {
        Effect : "Allow"
        Action : ["codestar-connections:UseConnection"]
        Resource : "${aws_codestarconnections_connection.github.arn}"
      },
      {
        Effect : "Allow"
        Action : ["codebuild:BatchGetBuilds", "codebuild:StartBuild"]
        Resource : "*"
      },
      {
        Effect   = "Allow"
        Action   = ["*"]
        Resource = ["*"]
      }
    ]
  })
}
