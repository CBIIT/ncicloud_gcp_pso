# Sample Terraform Script

These sample scripts  

1. Create the foundations project to store terraform state files in GCS buckets.
2. Create two projects with custom roles and GCP group binding

## Steps

### Foundations Project Setup

**Note: Skip this section if a foundation project to hold terraform state buckets is not required.**

1. Go to `terraform\environments\foundations` folder.
2. Comment all lines in `backend.tf` file.
3. Run `terraform init` command.
4. Run `terraform plan` command and inspect all the GCP resources that will be created/udpated/deleted.
5. Run `terraform apply` command to apply changes to GCP.
6. Run `terraform output bootstrap_tf_gcs_bucket` to get the name of GCS bucket created for bootstrap project.
7. Update the bucket name in `backend.tf` file and uncomment all lines.
8. Run `terraform output tf-gcs-project-factory` to get the name of GCS bucket created for factory project(s).
9. Update the bucket name in `terraform\environments\project-factory\backend.tf` file.

### Project Factory Setup

1. Go to `terraform\environments\project-factory` folder.
2. If **Foundations Project Setup** section was skipped then comment all lines in `backend.tf` file.
3. Run `terraform init` command.
4. Run `terraform plan` command and inspect all the GCP resources that will be created/udpated/deleted.
5. Run `terraform apply` command to apply changes to GCP.
