# Runtime identity for the "hello" Cloud Run service.
# One dedicated SA per service instead of the Compute Engine default SA
# (which often has the broad Editor role).
resource "google_service_account" "hello" {
  account_id   = "${local.name_prefix}-hello-runtime"
  display_name = "Cloud Run runtime SA for ${local.name_prefix}-hello"
  description  = "Runtime identity of the ${local.name_prefix}-hello Cloud Run service. Managed by Terraform."

  # Explicit dependency: the SA does not reference the API resource,
  # but it cannot be created until the IAM API is enabled.
  depends_on = [google_project_service.apis]
}

# Least privilege: grant only the roles listed in var.runtime_roles (none by default).
# _member is additive - it never removes grants managed outside Terraform.
resource "google_project_iam_member" "hello_runtime" {
  for_each = toset(var.runtime_roles)

  project = var.project_id
  role    = each.value
  member  = google_service_account.hello.member
}
