output "project_id" {
  description = "Project ID the configuration is deployed to."
  value       = data.google_project.this.project_id
}

output "project_number" {
  description = "Numeric project number (used in some IAM principals and service agents)."
  value       = data.google_project.this.number
}

output "hello_url" {
  description = "Public URL of the hello Cloud Run service."
  value       = module.hello.uri
}

output "hello_runtime_sa_email" {
  description = "Email of the runtime service account of the hello Cloud Run service."
  value       = module.hello.service_account_email
}

output "environment" {
  description = "Environment name."
  value       = var.environment
}
