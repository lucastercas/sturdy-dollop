locals {
  app_name    = "ebs-app"
  environment = "dev"
  tags = {
    CreatedBy   = "terraform"
    Project     = "ebs-app"
    Environment = "dev"
  }
}
