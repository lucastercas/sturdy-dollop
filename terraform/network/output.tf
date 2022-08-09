output "vpc" {
  value = {
    id : aws_vpc.oregon.id
  }
}

output "subnets" {
  value = {
    public : [for key, subnet in aws_subnet.public : subnet.id]
  }
}
