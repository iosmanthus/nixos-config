output "aws-lightsail-0-ip" {
  value     = aws_lightsail_static_ip.main.ip_address
  sensitive = true
}
