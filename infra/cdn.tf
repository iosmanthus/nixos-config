locals {
  records = { for site in var.websites : "${site.name}" => "${site.zone}" }
  zones   = toset([for site in var.websites : site.zone])
}
# Add CDN for the Caddy instance
resource "cloudflare_record" "main" {
  for_each = local.records
  value    = aws_lightsail_static_ip_attachment.main.ip_address
  zone_id  = each.value
  name     = each.key
  type     = "A"
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
