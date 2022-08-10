variable "webhook_secret" {
  default = "very-secreto-secret"
}

resource "aws_codepipeline_webhook" "app" {
  name            = "app-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.pipeline.name
  authentication_configuration {
    secret_token = var.webhook_secret
  }
  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

#resource "github_repository_webhook" "app" {
#  repository = "${var.repo_user}/${var.repo_name}"
#  configuration {
#    url          = aws_codepipeline_webhook.app.url
#    content_type = "json"
#    insecure_ssl = true
#    secret       = var.webhook_secret
#  }
#  events = ["push"]
#}
