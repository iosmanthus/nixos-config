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

module "gcp_instance_0" {
  source = "./gce"

  google_project            = var.google_project
  google_service_account_id = var.google_service_account_id
  vm_image                  = google_compute_image.nixos.self_link

  google_region = "asia-east1"
  google_zone   = "asia-east1-b"
  ip_revision   = "202405061637"
}

module "gcp_instance_1" {
  source = "./gce"

  google_project            = var.google_project
  google_service_account_id = var.google_service_account_id
  vm_image                  = google_compute_image.nixos.self_link

  google_region = "us-west1"
  google_zone   = "us-west1-b"
  ip_revision   = "20240401173637"
}
