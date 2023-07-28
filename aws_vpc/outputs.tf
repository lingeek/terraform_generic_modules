output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.vpc_name.id
}

output "public_subnet_ids" {
    description = "Public subnets"
    value = values(aws_subnet.public_subnet)[*].id
}

output "private_subnet_ids" {
    description = "Private subnets"
    value = values(aws_subnet.private_subnet)[*].id
}

output "nat_gateway_id" {
    description = "NAT gateway ID"
    value = aws_nat_gateway.nat_gateway.id
}
