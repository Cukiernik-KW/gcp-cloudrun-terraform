output "project_id" {
  description = "Project ID the configuration is deployed to."
  value       = data.google_project.this.project_id
}

output "project_number" {
  description = "Numeric project number (used in some IAM principals and service agents)."
  value       = data.google_project.this.number
}

output "environment" {
  description = "Environment name."
  value       = var.environment
}
