output "name" {
  description = "Cloud Run service name."
  value       = google_cloud_run_v2_service.this.name
}

output "uri" {
  description = "HTTPS URL of the service."
  value       = google_cloud_run_v2_service.this.uri
}

output "service_account_email" {
  description = "Email of the runtime service account."
  value       = google_service_account.this.email
}

output "service_account_member" {
  description = "Runtime SA as an IAM member (\"serviceAccount:...\"), ready to pass to another service's invoker_members."
  value       = google_service_account.this.member
}
