resource "google_service_account" "main" {
  account_id   = "tf-20240628195450"
  display_name = "Terraform Administrator"
}

resource "google_compute_image" "nixos" {
  name   = "nixos-v20240701161159"
  family = "nixos-24-05"
  raw_disk {
    source = "https://storage.cloud.google.com/nixos-cloud-images-20240701160523/nixos-image-24.11.20240524.bfb7a88-x86_64-linux.raw.tar.gz"
  }
}

resource "google_compute_image_iam_binding" "binding" {
  project = google_compute_image.nixos.project
  image   = google_compute_image.nixos.name
  role    = "roles/compute.imageUser"
  members = [
    google_service_account.main.member
  ]
}

module "gcp_instance_0" {
  source = "./gce"

  google_project            = var.google_project
  google_service_account_id = google_service_account.main.id
  vm_image                  = google_compute_image.nixos.self_link

  google_region = "asia-east1"
  google_zone   = "asia-east1-b"
  ip_revision   = "20240704003503"
}

module "gcp_instance_1" {
  source = "./gce"

  google_project            = var.google_project
  google_service_account_id = google_service_account.main.id
  vm_image                  = google_compute_image.nixos.self_link

  google_region = "us-west1"
  google_zone   = "us-west1-b"
  ip_revision   = "20240704003503"
}
