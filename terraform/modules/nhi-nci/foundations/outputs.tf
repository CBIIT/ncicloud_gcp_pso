output "terraform_project" {
  description = "Project that holds the base Terraform resources."
  value = {
    id   = module.tf-project.project_id
    name = module.tf-project.name
  }
}

output "bootstrap_tf_gcs_bucket" {
  description = "GCS bucket used for the bootstrap Terraform state."
  value       = module.tf-gcs-bootstrap.name
}

output "tf-gcs-project-factory" {
  description = "GCS bucket used for the project factory Terraform state."
  value       = module.tf-gcs-project-factory.name
}