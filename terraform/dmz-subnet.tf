resource "aws_subnet" "dmz" {
  count                   = length(var.dmz_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.dmz_subnets, count.index)
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.infra}-${var.environment}-dmz-subnet"
  }
}

resource "aws_route_table" "dmz-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.infra}-${var.environment}-dmz-rt"
  }
}

resource "aws_route_table_association" "dmz-rt-assoc" {
  count          = length(var.dmz_subnets)
  subnet_id      = aws_subnet.dmz.*.id[count.index]
  route_table_id = aws_route_table.dmz-rt.id
  depends_on     = [aws_subnet.dmz]
}