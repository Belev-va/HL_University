output "public_security_group_id" {
  description = "The ID of the security group"
  value = length(aws_security_group.public_sg) > 0 ? aws_security_group.public_sg[0].id : null
}

output "private_security_group_id" {
  value = length(aws_security_group.private_sg) > 0 ? aws_security_group.private_sg[0].id : null
}
