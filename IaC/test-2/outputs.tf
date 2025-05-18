output "public_instance_ip" {
  value = module.public_instance.public_instance_ips

}
output "ansible_ip" {
  value = module.public_instance_2.public_instance_ips
}
output "private_instance_ip" {
  value = module.private_instance.private_instance_ips
}
