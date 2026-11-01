# --- Required inputs ---

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region of the Cloud Run service."
  type        = string
}

variable "name" {
  description = "Service name, e.g. \"dev-api\". Also used to name the runtime SA (\"<name>-runtime\")."
  type        = string

  validation {
    # SA account_id is max 30 chars; "-runtime" adds 8.
    condition     = can(regex("^[a-z][a-z0-9-]{4,20}[a-z0-9]$", var.name))
    error_message = "name must be 6-22 chars: lowercase letters, digits, hyphens; start with a letter."
  }
}

# --- Optional inputs (secure defaults) ---

variable "image" {
  description = "Container image. In real CI/CD, pass an immutable digest."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "runtime_roles" {
  description = "Project-level IAM roles for the runtime SA. Least privilege: empty by default."
  type        = list(string)
  default     = []
}

variable "public" {
  description = "If true, allUsers get roles/run.invoker (public, unauthenticated access)."
  type        = bool
  default     = false
}

variable "invoker_members" {
  description = "Additional IAM members allowed to invoke the service, e.g. [\"serviceAccount:x@p.iam.gserviceaccount.com\"]."
  type        = list(string)
  default     = []
}

variable "min_instances" {
  description = "Minimum number of instances. 0 = scale to zero (no cost when idle)."
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances (caps cost and blast radius)."
  type        = number
  default     = 2
}

variable "cpu" {
  description = "CPU limit per instance."
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory limit per instance."
  type        = string
  default     = "512Mi"
}

variable "deletion_protection" {
  description = "Prevents terraform destroy of the service. Keep true in production."
  type        = bool
  default     = true
}
