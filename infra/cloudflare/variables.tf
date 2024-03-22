variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "websites" {
  type = list(object({
    name = string
    zone = string
  }))
}
