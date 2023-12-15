locals {
  availability_zone = "${var.aws_region}a"
  blueprint_id      = "ubuntu_22_04"
  bundle_id         = "micro_3_0"
  ip_address_type   = "dualstack"
  user_data         = <<-EOT
    #!/bin/sh
    curl https://raw.githubusercontent.com/iosmanthus/nixos-infect/fix-lightsail-boot-device/nixos-infect | NIX_CHANNEL=nixos-23.05 PROVIDER="lightsail" bash 2>&1 | tee /tmp/infect.log
   EOT 

  public_key = file("../secrets/iosmanthus/id_rsa_iosmanthus.pub")
}

resource "random_id" "instance" {
  byte_length = 4
}

resource "aws_lightsail_instance" "main" {
  name = "lightsail-${random_id.instance.hex}"

  availability_zone = local.availability_zone
  blueprint_id      = local.blueprint_id
  bundle_id         = local.bundle_id
  ip_address_type   = local.ip_address_type
  user_data         = local.user_data

  key_pair_name = aws_lightsail_key_pair.main.name
}

resource "aws_lightsail_key_pair" "main" {
  name = "ssh-key-${random_id.instance.hex}"

  public_key = local.public_key
}

resource "random_id" "ip" {
  byte_length = 4

  keepers = {
    ip_version = var.ip_revision
  }
}

resource "aws_lightsail_static_ip" "main" {
  name = "ip-${random_id.ip.hex}"
}

resource "aws_lightsail_static_ip_attachment" "main" {
  instance_name  = aws_lightsail_instance.main.id
  static_ip_name = aws_lightsail_static_ip.main.id
}

# Disable firewall provided by Lightsail, use NixOS's firewall instead.
resource "aws_lightsail_instance_public_ports" "main" {
  instance_name = aws_lightsail_instance.main.name
  port_info {
    from_port = 0
    to_port   = 65535
    protocol  = "all"
  }
}
