# Public front service (acts as the BFF).
module "hello" {
  source = "./modules/cloud_run_service"

  project_id    = var.project_id
  region        = var.region
  name          = "${local.name_prefix}-hello"
  image         = var.hello_image
  runtime_roles = var.runtime_roles
  public        = true

  # LAB ONLY: allows terraform destroy in the cleanup step.
  deletion_protection = false

  # Nothing in the module can be created before the APIs are enabled.
  depends_on = [google_project_service.apis]
}
