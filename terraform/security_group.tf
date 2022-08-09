resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "app-sg"
  vpc_id      = module.network.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "app-sg"
  })
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "app-sg"
  vpc_id      = module.network.vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.app_sg.id]
    protocol        = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "rds-sg"
  })
}