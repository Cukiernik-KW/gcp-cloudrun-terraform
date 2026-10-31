terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }

  # Partial backend configuration: the bucket name is NOT hardcoded here.
  # Pass it at init time:  terraform init -backend-config=backend.tfbackend
  # Backend blocks cannot use variables - they are evaluated before anything else.
  backend "gcs" {
    prefix = "gcp-cloudrun-terraform/dev"
  }
}
