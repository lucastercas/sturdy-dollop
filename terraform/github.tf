resource "aws_codestarconnections_connection" "github" {
  provider_type = "GitHub"
  name          = "app-connection"

}
