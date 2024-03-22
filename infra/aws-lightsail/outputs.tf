output "external_address_v4" {
  value     = aws_lightsail_static_ip.main.ip_address
  sensitive = true
}

output "external_address_v6" {
  value     = aws_lightsail_instance.main.ipv6_addresses[0]
  sensitive = true
}
