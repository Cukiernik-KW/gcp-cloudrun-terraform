terraform {
  required_version = ">= 1.6"

  # Declare the provider requirement only. No provider block here:
  # the module inherits the provider configuration from its caller.
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0, < 8.0"
    }
  }
}
