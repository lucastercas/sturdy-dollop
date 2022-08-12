resource "aws_subnet" "public" {
  for_each                = { for idx, az in var.availability_zones : az => idx }
  vpc_id                  = aws_vpc.oregon.id
  cidr_block              = cidrsubnet(aws_vpc.oregon.cidr_block, local.subnet_cidr_bits, 8 + each.value)
  map_public_ip_on_launch = true
  availability_zone       = each.key
  tags = merge(var.tags, {
    Name = "public-${var.app_name}-${each.key}"
    Type = "public"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.oregon.id
  tags = merge(var.tags, {
    Name = "${var.app_name}-igw"
  })
}

resource "aws_route_table" "public" {
  for_each = aws_subnet.public
  vpc_id   = aws_vpc.oregon.id

  tags = merge(var.tags, {
    Name = "public-${var.app_name}-${each.key}"
  })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route" "public" {
  for_each               = aws_subnet.public
  route_table_id         = aws_route_table.public[each.key].id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_eip" "nat_eip" {
  for_each = aws_subnet.public
  vpc      = true
  tags = merge(var.tags, {
    Name = "${var.app_name}-${each.key}"
  })
}

resource "aws_nat_gateway" "public" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags = merge(var.tags, {
    Name = "${var.app_name}-${each.key}"
  })
}
