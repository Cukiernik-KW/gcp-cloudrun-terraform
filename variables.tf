variable "project_id" {
  description = "GCP project ID where all resources are created."
  type        = string
  # No default: must be set explicitly to avoid deploying to the wrong project.
}

variable "region" {
  description = "GCP region for regional resources (Cloud Run)."
  type        = string
  default     = "europe-central2"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "region must be a GCP region name, e.g. europe-central2."
  }
}

variable "hello_image" {
  description = "Container image of the hello service. In real CI/CD, pass an immutable digest."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "runtime_roles" {
  description = "Project-level IAM roles for the Cloud Run runtime service account. Empty by default: the sample app calls no Google APIs."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name, used in resource names and labels."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
