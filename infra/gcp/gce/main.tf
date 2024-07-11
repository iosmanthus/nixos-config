resource "random_id" "revision" {
  keepers = {
    creation_timestamp = "20240628151839"
  }
  byte_length = 4
}

data "google_service_account" "default" {
  account_id = var.google_service_account_id
}

resource "random_id" "ip_revision" {
  keepers = {
    ip_revision = var.ip_revision
  }
  byte_length = 4
}

resource "google_compute_address" "main_external_ip_v4" {
  name = "external-ip-v4-${random_id.revision.hex}-${random_id.ip_revision.hex}"

  region = var.google_region
}

resource "google_compute_subnetwork" "dual_stack" {
  region           = var.google_region
  name             = "dual-stack-${random_id.revision.hex}"
  ip_cidr_range    = "10.0.0.0/22"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"

  network = google_compute_network.main.id
}

resource "google_compute_network" "main" {
  name                    = "main-${random_id.revision.hex}"
  auto_create_subnetworks = false
  mtu                     = 8896
}

resource "google_compute_firewall" "main" {
  name    = "main-${random_id.revision.hex}"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "10080"]
  }

  allow {
    protocol = "udp"
    ports    = ["10853"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "main_v6" {
  name    = "main-v6-${random_id.revision.hex}"
  network = google_compute_network.main.name

  allow {
    protocol = "58"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "10080"]
  }

  source_ranges = ["::/0"]
}

resource "google_compute_instance" "main" {
  name         = "instance-${random_id.revision.hex}"
  machine_type = "e2-micro"

  enable_display            = true
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.vm_image
      type  = "pd-balanced"
      size  = 40
    }
  }


  network_interface {
    subnetwork = google_compute_subnetwork.dual_stack.self_link
    stack_type = "IPV4_IPV6"
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    access_config {
      nat_ip = google_compute_address.main_external_ip_v4.address
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = data.google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
