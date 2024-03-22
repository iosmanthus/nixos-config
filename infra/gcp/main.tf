resource "random_id" "revision" {
  keepers = {
    creation_timestamp = "20240320173139"
  }
  byte_length = 4
}

data "google_service_account" "default" {
  account_id = var.google_service_account_id
}

resource "google_compute_image" "nixos" {
  name   = "nixos-v202403201639"
  family = "nixos-24-05"
  raw_disk {
    source = "https://storage.cloud.google.com/iosmanthus-nixos-cloud-images/nixos-image-24.05.20240228.9099616-x86_64-linux.raw.tar.gz"
  }
}

resource "google_compute_image_iam_binding" "binding" {
  project = google_compute_image.nixos.project
  image   = google_compute_image.nixos.name
  role    = "roles/compute.imageUser"
  members = [
    "serviceAccount:${data.google_service_account.default.email}",
  ]
}

resource "random_id" "ip_revision" {
  keepers = {
    creation_timestamp = "20240320174539"
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
}

resource "google_compute_firewall" "main" {
  name    = "main-${random_id.revision.hex}"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "6626", "10080"]
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
    ports    = ["22", "443", "6626", "10080"]
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
      image = google_compute_image.nixos.self_link
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
