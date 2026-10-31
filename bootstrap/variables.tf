variable "project_id" {
  description = "GCP project ID where the Terraform state bucket is created."
  type        = string
  # No default: must be set explicitly to avoid deploying to the wrong project.
}

variable "region" {
  description = "Location of the state bucket (single region keeps cost low)."
  type        = string
  default     = "europe-central2"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "region must be a GCP region name, e.g. europe-central2."
  }
}
