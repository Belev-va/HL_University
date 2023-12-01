output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.dev_vpc_public_subnet.id
}
output "private_subnet_id" {
  value = aws_subnet.dev_vpc_private_subnet.id
}
output "vpc_cidr" {
  value = aws_vpc.dev_vpc.cidr_block
}
output "aws_eip" {
  value = aws_eip.dev_eip.address
}
output "default_security_group" {
  value = aws_security_group.dev_sg.name

}
