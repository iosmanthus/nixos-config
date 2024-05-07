variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "aws_lightsail_records" {
  type = list(object({
    atype   = string
    name    = string
    origin  = string
    proxied = bool
    zone    = string
  }))
}

variable "gcp_records" {
  type = list(object({
    atype   = string
    name    = string
    origin  = string
    proxied = bool
    zone    = string
  }))
}
