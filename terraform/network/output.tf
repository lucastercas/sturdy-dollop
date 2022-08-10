output "vpc" {
  value = {
    id         = aws_vpc.oregon.id
    cidr_block = aws_vpc.oregon.cidr_block
  }
}

output "subnets" {
  value = {
    public  = [for key, subnet in aws_subnet.public : subnet.id]
    private = [for key, subnet in aws_subnet.private : subnet.id]
  }
}
