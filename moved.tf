# Refactor: hello resources moved from the root module into module.hello.
# Without these blocks Terraform would DESTROY the old addresses and CREATE
# new ones (downtime, new SA identity). With them it only renames addresses
# in the state - no changes in GCP.
# Can be deleted once every state using this config has been applied.

moved {
  from = google_service_account.hello
  to   = module.hello.google_service_account.this
}

moved {
  from = google_project_iam_member.hello_runtime
  to   = module.hello.google_project_iam_member.runtime
}

moved {
  from = google_cloud_run_v2_service.hello
  to   = module.hello.google_cloud_run_v2_service.this
}

# Single resource -> one instance of a for_each resource (key "allUsers").
moved {
  from = google_cloud_run_v2_service_iam_member.hello_public
  to   = module.hello.google_cloud_run_v2_service_iam_member.invokers["allUsers"]
}
