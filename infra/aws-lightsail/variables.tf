variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "ip_revision" {
  type    = number
  default = 0
}
