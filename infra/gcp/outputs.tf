output "external_address_v4" {
  value     = google_compute_address.main_external_ip_v4.address
  sensitive = true
}

output "external_address_v6" {
  value     = google_compute_instance.main.network_interface[0].ipv6_access_config[0].external_ipv6
  sensitive = true
}
