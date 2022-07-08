resource "aws_subnet" "app" {
  count      = length(var.app_subnets)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.app_subnets, count.index)
  tags = {
    Name = "${var.infra}-${var.environment}-app-subnet"
  }
  availability_zone = var.az[count.index]
}

resource "aws_route_table" "app-rt" {

  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
}

resource "aws_route_table_association" "app" {
  count          = length(var.app_subnets)
  route_table_id = aws_route_table.app-rt.id
  subnet_id      = aws_subnet.app.*.id[count.index]
}