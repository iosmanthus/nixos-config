locals {
  records = { for site in var.websites : "${site.name}" => "${site.zone}" }
  zones   = toset([for site in var.websites : site.zone])
}

data "terraform_remote_state" "aws_lightsail" {
  backend = "local"
  config = {
    path = "../aws-lightsail/terraform.tfstate"
  }
}

resource "cloudflare_record" "aws_lightsail" {
  for_each = local.records
  value    = data.terraform_remote_state.aws_lightsail.outputs.external_address_v4
  zone_id  = each.value
  name     = each.key
  type     = "A"
  proxied  = true
}

resource "cloudflare_record" "aws_lightsail_v6" {
  for_each = local.records
  value    = data.terraform_remote_state.aws_lightsail.outputs.external_address_v6
  zone_id  = each.value
  name     = each.key
  type     = "AAAA"
  proxied  = true
}

resource "cloudflare_zone_settings_override" "enable_https" {
  for_each = local.zones
  zone_id  = each.value
  settings {
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "strict"
  }
}
