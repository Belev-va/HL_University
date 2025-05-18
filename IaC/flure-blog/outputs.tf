output "lightsail_static_ip" {
  description = "Static IP for Lightsail-Instance"
  value       = aws_lightsail_static_ip.wp_static_ip.ip_address
}

