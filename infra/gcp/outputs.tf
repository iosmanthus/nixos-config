output "gcp_instance_0_external_address_v4" {
  value     = module.gcp_instance_0.external_address_v4
  sensitive = true
}

output "gcp_instance_0_external_address_v6" {
  value     = module.gcp_instance_0.external_address_v6
  sensitive = true
}
