provider "google" {
  project = var.project_id
  region  = var.region

  # Applied automatically to every resource that supports labels.
  default_labels = {
    app         = "gcp-cloudrun-terraform"
    environment = var.environment
    managed-by  = "terraform"
  }
}
