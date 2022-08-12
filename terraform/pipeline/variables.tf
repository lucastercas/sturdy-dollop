variable "environment" {
  type = string
}

variable "app_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "repo_user" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "repo_branch" {
  type = string
}

variable "ebs_application_name" {
  type = string
}

variable "ebs_environment_name" {
  type = string
}

variable "ebs_arn" {
  type        = string
  description = "ARN of the Elastic Beanstalk Application"
}

variable "codestar_connection_arn" {
  type = string
}
