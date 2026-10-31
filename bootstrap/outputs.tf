output "state_bucket_name" {
  description = "Name of the GCS bucket to use in the main config's backend \"gcs\" block."
  value       = google_storage_bucket.tfstate.name
}

output "state_bucket_url" {
  description = "gs:// URL of the state bucket."
  value       = google_storage_bucket.tfstate.url
}
