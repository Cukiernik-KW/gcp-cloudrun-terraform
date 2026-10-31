locals {
  required_apis = toset([
    "run.googleapis.com", # Cloud Run
    "iam.googleapis.com", # Service accounts
  ])
}

# One resource per API. Keys are API names, so removing one from the list
# does not shift or recreate the others (unlike count).
resource "google_project_service" "apis" {
  for_each = local.required_apis

  project = var.project_id
  service = each.value

  # APIs are project-wide: other workloads may use them, so never disable
  # them on destroy.
  disable_on_destroy = false
}
