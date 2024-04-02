provider "google" {
  project = var.google_project
  region  = var.google_region
  zone    = var.google_zone

  user_project_override = true
}
