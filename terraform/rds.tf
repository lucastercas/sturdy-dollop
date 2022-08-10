resource "aws_db_subnet_group" "db" {
  name       = "main"
  subnet_ids = module.network.subnets.private
  tags       = merge(local.tags, {})
}

resource "aws_db_instance" "db" {
  engine = "postgres"

  instance_class = "db.t3.micro"
  identifier     = "app-db-dev"

  db_name  = "app"
  username = "lucastercas"
  password = "temporary_password"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db.name
  publicly_accessible    = false

  allocated_storage     = 50
  max_allocated_storage = 100

  skip_final_snapshot = true

  tags = merge(local.tags, {
    Name = "app-db"
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
    cidr_blocks = [module.network.vpc.cidr_block]
  }

  tags = merge(local.tags, {
    Name = "rds-sg"
  })
}
