locals {
  # Everyone allowed to call the service: allUsers if public, plus explicit members.
  invokers = toset(concat(var.public ? ["allUsers"] : [], var.invoker_members))
}

# Dedicated runtime identity - every service gets its own SA, never the
# Compute Engine default SA.
resource "google_service_account" "this" {
  project      = var.project_id
  account_id   = "${var.name}-runtime"
  display_name = "Cloud Run runtime SA for ${var.name}"
  description  = "Runtime identity of the ${var.name} Cloud Run service. Managed by Terraform."
}

# Least privilege: only the roles the caller asks for (none by default).
# _member is additive - never removes grants managed elsewhere.
resource "google_project_iam_member" "runtime" {
  for_each = toset(var.runtime_roles)

  project = var.project_id
  role    = each.value
  member  = google_service_account.this.member
}

resource "google_cloud_run_v2_service" "this" {
  project  = var.project_id
  name     = var.name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  deletion_protection = var.deletion_protection

  # Everything inside template is a revision: changing it deploys a new revision.
  template {
    service_account = google_service_account.this.email

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    containers {
      image = var.image

      ports {
        container_port = 8080
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
        cpu_idle = true # CPU billed only while handling requests
      }
    }
  }
}

# Who may invoke the service, modelled explicitly. Keyed by member,
# e.g. invokers["allUsers"] or invokers["serviceAccount:..."].
resource "google_cloud_run_v2_service_iam_member" "invokers" {
  for_each = local.invokers

  project  = google_cloud_run_v2_service.this.project
  location = google_cloud_run_v2_service.this.location
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = each.value
}
