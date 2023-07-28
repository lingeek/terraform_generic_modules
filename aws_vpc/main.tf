resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_ciddr
  tags = merge(
    var.business_tags,
    var.technical_vpc_tags,
    var.security_tags,
    #Individual tags
    {
    "Name"          = "${local.lifecycle}-${var.vpc_name}"
    "CreationDate"  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    }
    #End Individual tags
  )
}

#Public subnets
resource "aws_subnet" "public_subnet" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc_name.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    var.business_tags,
    var.technical_vpc_public_subnet_tags,
    var.security_tags,
    #Individual tags
    {
    "Name"          = "${local.lifecycle}-${each.key}-Public-subnet"
    "CreationDate"  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    }
    #End Individual tags
  )
  }
#End Public subnets

# Private subnets
resource "aws_subnet" "private_subnet" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.vpc_name.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    var.business_tags,
    var.technical_vpc_private_subnet_tags,
    var.security_tags,
    #Individual tags
    {
    "Name"          = "${local.lifecycle}-${each.key}-private-subnet"
    "CreationDate"  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    }
    #End Individual tags
  )
}
#End Private subnets
#End Subnets

#Elastic IP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
#End Elastic IP

#Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_name.id

  tags = merge(
    var.business_tags,
    var.security_tags,
    #Individual tags
    {
    "Name"          = "${local.lifecycle}-internet-gateway"
    "CreationDate"  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    }
    #End Individual tags
  )
  }
#End Internet gateway

#NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = var.public_subnets[var.nat_gateway_subnet]["subnet_id"]

  tags = merge(
    var.business_tags,
    var.security_tags,
    #Individual tags
    {
    "Name"          = "${local.lifecycle}-nat-gateway"
    "CreationDate"  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    }
    #End Individual tags
  )

  #Ordering resource creation.
  depends_on        = [aws_internet_gateway.internet_gateway]
}
#End NAT Gateway

# Create route tables for private subnets
resource "aws_route_table" "private_route_table" {
  for_each         = aws_subnet.private_subnet
  vpc_id           = aws_vpc.vpc_name.id

  tags = merge(
    var.business_tags,
    var.security_tags,
    #Individual tags
    {
    "Name"          = "${local.lifecycle}-${each.key}-private-route-table"
    "CreationDate"  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    }
    #End Individual tags
  )
}
#End Create route tables for private subnets

# Create routes to NAT gateway in each private route table
resource "aws_route" "private_route" {
  for_each               = aws_route_table.private_route_table
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id

}
#End Create routes to NAT gateway in each private route table

# Associate private route tables with private subnets
resource "aws_route_table_association" "private_route_association" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table[each.key].id
}
#End Associate private route tables with private subnets

#Public subnets router and route tables
# Create route tables for private subnets
resource "aws_route_table" "public_route_table" {
  for_each          = aws_subnet.public_subnet
  vpc_id            = aws_vpc.vpc_name.id

  tags = merge(
    var.business_tags,
    var.security_tags,
    #Individual tags
    {
    "Name"          = "${local.lifecycle}-${each.key}-public-route-table"
    "CreationDate"  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    }
    #End Individual tags
  )
}
#End Create route tables for private subnets


# Create routes to Internet gateway in each public route table
resource "aws_route" "internet_gateway_public_route" {
  for_each                = aws_route_table.public_route_table
  route_table_id          = aws_route_table.public_route_table[each.key].id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.internet_gateway.id
}
#End Create routes to Internet gateway in each public route table


# Associate public route tables with public subnets
resource "aws_route_table_association" "public_route_association" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table[each.key].id
}
#End Associate public route tables with public subnets
#End
