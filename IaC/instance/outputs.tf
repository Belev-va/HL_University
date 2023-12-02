output "public_instance_ips" {
  value = aws_instance.instance.*.public_ip
}
output "private_instance_ips" {
  value = aws_instance.instance.*.private_ip
}