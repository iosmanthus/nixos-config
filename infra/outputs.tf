output "aws-lightsail-0-ipv4" {
  value     = aws_lightsail_static_ip.main.ip_address
  sensitive = true
}

output "aws-lightsail-0-ipv6" {
  value     = aws_lightsail_instance.main.ipv6_addresses[0]
  sensitive = true
}
