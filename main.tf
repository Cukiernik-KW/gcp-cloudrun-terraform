# Data source: READS an existing object, never creates or changes it.
# Here: our own project, to get its numeric project_number.
data "google_project" "this" {
  project_id = var.project_id
}

locals {
  # Common prefix for resource names, e.g. "dev-api".
  name_prefix = var.environment
}
