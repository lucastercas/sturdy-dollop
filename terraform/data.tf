data "aws_elastic_beanstalk_solution_stack" "app" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux 2 (.*) running Ruby 2.7$"
}
