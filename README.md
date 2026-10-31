# gcp-cloudrun-terraform

Infrastructure as Code for Cloud Run on Google Cloud, built with Terraform.

> Work in progress - built step by step as a learning project. Full documentation
> (architecture, decisions, production notes) will be added at the end.

## Roadmap

- [x] Bootstrap: GCS bucket for remote Terraform state (versioning, locked down)
- [x] Root config: `gcs` backend, pinned provider, variables, outputs
- [x] Enable required APIs (`google_project_service`)
- [x] Dedicated least-privilege runtime service account
- [ ] Cloud Run v2 service with public access modelled as a separate IAM binding
- [ ] Reusable module `modules/cloud_run_service`, used for `api` and `bff`
- [ ] Drift detection demo
- [ ] `terraform import` demo
- [ ] CI/CD: GitHub Actions with Workload Identity Federation (no JSON keys)
- [ ] Cleanup: `terraform destroy`

## Repository layout

```
bootstrap/                  # one-off config with LOCAL state that creates the remote state bucket
*.tf                        # root module (state stored remotely in GCS)
backend.tfbackend.example   # partial backend config (bucket name kept out of code)
terraform.tfvars.example    # variable values template
```
