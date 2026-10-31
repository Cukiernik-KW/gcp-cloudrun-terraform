resource "google_storage_bucket" "tfstate" {
  # Bucket names are global across all of GCP, so prefix with project ID.
  name          = "${var.project_id}-tfstate"
  location      = upper(var.region)
  storage_class = "STANDARD"

  # Keep history of state files - lets us roll back a corrupted state.
  versioning {
    enabled = true
  }

  # Access controlled only by IAM (no legacy per-object ACLs).
  uniform_bucket_level_access = true

  # State can contain secrets - make it impossible to expose publicly.
  public_access_prevention = "enforced"

  # Keep at most 10 old versions of each state file to limit cost.
  lifecycle_rule {
    condition {
      num_newer_versions = 10
      with_state         = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }

  # LAB ONLY: allows deleting a non-empty bucket in the cleanup step.
  # In production: force_destroy = false + lifecycle { prevent_destroy = true }.
  force_destroy = true

  labels = {
    purpose    = "terraform-state"
    managed-by = "terraform"
  }
}
