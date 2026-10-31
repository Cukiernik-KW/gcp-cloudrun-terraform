terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }

  # No backend block on purpose: bootstrap keeps LOCAL state,
  # because the remote state bucket does not exist yet (chicken-and-egg).
}

provider "google" {
  project = var.project_id
  region  = var.region
}
