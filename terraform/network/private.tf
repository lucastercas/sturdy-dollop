resource "aws_subnet" "private" {
  for_each          = { for idx, az in var.availability_zones : az => idx }
  vpc_id            = aws_vpc.oregon.id
  cidr_block        = cidrsubnet(aws_vpc.oregon.cidr_block, local.subnet_cidr_bits, each.value)
  availability_zone = each.key
  tags = merge(var.tags, {
    Name = "private-${var.app_name}-${each.key}"
    Type = "private"
  })
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.oregon.id
  tags = merge(var.tags, {
    Name = "private-${var.app_name}-${each.key}"
    Type = "private"
  })
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route" "private_to_public" {
  for_each               = aws_subnet.private
  route_table_id         = aws_route_table.private[each.key].id
  nat_gateway_id         = aws_nat_gateway.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
}
