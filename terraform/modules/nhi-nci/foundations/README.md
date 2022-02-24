# Foundations Module

This sample module creates the foundations project to store terraform state files in GCS buckets.

## Example

```hcl
module "nhi-nci-foundations" {
  source               = "../../modules/nhi-nci/foundations"

  billing_account_id   = "<"Billing Account Id>"
  root_node            = "folders/171339314200"
  prefix               = "nhi-nci"
  iam_terraform_owners = ["user:farrukhhashmi@google.com"]
}
```

<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---: |:---:|:---:|
| billing_account_id | Billing account account. | `string` | ✓ |  |
| root_node | Root node in folders/folder_id or organizations/org_id format. | `string` | ✓ |  |
| prefix | Optional prefix used for GCS bucket names to ensure uniqueness. | `string` |  | `null`|
| project_id | Project id. | `string` | ✓ |  |
| *iam_terraform_owners* | Optional Terraform project owners, in IAM format. | `list(string)` |  | `[]` |
| *iam* | Optional IAM bindings for the project in {ROLE => [MEMBERS]} format. | `map(list(string))`|  | `{}`</code> |
| *project_services* | Optional Service APIs to be enabled in projects. | `list(string)`|  | `[]`|
| *gcs_defaults* | Defaults use for the state GCS buckets. | `map(string)`|  |`location      = "NAM4"  storage_class = "STANDARD"` |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| terraform_project | Project that holds the base Terraform resources. |  |
| bootstrap_tf_gcs_bucket | GCS bucket used for the bootstrap Terraform state. |  |
| tf-gcs-project-factory | GCS bucket used for the project factory Terraform state. |  |
<!-- END TFDOC -->
