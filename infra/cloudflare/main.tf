locals {
  aws_lightsail_records = { for site in var.aws_lightsail_records : "${site.name}/${site.atype}" => {
    name    = site.name
    origin  = site.origin
    zone    = site.zone
    atype   = site.atype
    proxied = site.proxied
  } }
  aws_lightsail_zones = toset([for site in var.aws_lightsail_records : site.zone if site.proxied])

  gcp_records = { for site in var.gcp_records : "${site.name}/${site.atype}" => {
    name    = site.name
    origin  = site.origin
    zone    = site.zone
    atype   = site.atype
    proxied = site.proxied
  } }
  gcp_zones = toset([for site in var.gcp_records : site.zone if site.proxied])
}

data "terraform_remote_state" "aws_lightsail" {
  backend = "local"
  config = {
    path = "./states/aws-lightsail/terraform.tfstate"
  }
}

data "terraform_remote_state" "gcp" {
  backend = "local"
  config = {
    path = "./states/gcp/terraform.tfstate"
  }
}

resource "cloudflare_record" "aws_lightsail" {
  for_each = local.aws_lightsail_records
  value    = data.terraform_remote_state.aws_lightsail.outputs[each.value.origin]
  name     = each.value.name
  proxied  = each.value.proxied
  type     = each.value.atype
  zone_id  = each.value.zone
}

resource "cloudflare_record" "gcp" {
  for_each = local.gcp_records
  value    = data.terraform_remote_state.gcp.outputs[each.value.origin]
  name     = each.value.name
  proxied  = each.value.proxied
  type     = each.value.atype
  zone_id  = each.value.zone
}

resource "cloudflare_zone_settings_override" "aws_lightsail_enable_https" {
  for_each = local.aws_lightsail_zones
  zone_id  = each.value
  settings {
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "strict"
  }
}

resource "cloudflare_zone_settings_override" "gcp_enable_https" {
  for_each = local.gcp_zones
  zone_id  = each.value
  settings {
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "strict"
  }
}
