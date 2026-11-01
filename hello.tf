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

# The Cloud Run service itself. No depends_on needed: referencing the SA email
# creates an implicit dependency, and the SA already depends on the APIs.
resource "google_cloud_run_v2_service" "hello" {
  name     = "${local.name_prefix}-hello"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  # LAB ONLY: allows terraform destroy in the cleanup step.
  # Provider default is true - keep it true in production.
  deletion_protection = false

  # Everything inside template is a revision: changing it deploys a new revision.
  template {
    service_account = google_service_account.hello.email

    scaling {
      min_instance_count = 0 # scale to zero = no cost when idle
      max_instance_count = 2 # cap cost and blast radius
    }

    containers {
      image = var.hello_image

      ports {
        container_port = 8080
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
        cpu_idle = true # CPU billed only while handling requests
      }
    }
  }
}

# Public access modelled explicitly as a separate IAM resource
# (what `gcloud run deploy --allow-unauthenticated` does implicitly).
# _member is additive: other invokers granted elsewhere are kept.
resource "google_cloud_run_v2_service_iam_member" "hello_public" {
  project  = google_cloud_run_v2_service.hello.project
  location = google_cloud_run_v2_service.hello.location
  name     = google_cloud_run_v2_service.hello.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
