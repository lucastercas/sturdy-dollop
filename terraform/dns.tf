data "aws_elb" "ebs_lb" {
  name = aws_elastic_beanstalk_environment.app_dev.load_balancers[0]
}

data "aws_route53_zone" "lucastercas_xyz" {
  name         = "lucastercas.xyz"
  private_zone = false
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.lucastercas_xyz.id
  name    = "app.${data.aws_route53_zone.lucastercas_xyz.name}"
  type    = "A"
  alias {
    name                   = aws_elastic_beanstalk_environment.app_dev.cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current.id
    evaluate_target_health = true
  }
}
