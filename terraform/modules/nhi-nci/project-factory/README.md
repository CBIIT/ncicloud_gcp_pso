# Project Factory Module

This sample module allows creation of a project with custom role(s).
This module accepts list of custom roles and their mapping to Google Groups.
It creates all custom roles passed to the module by end user in the project and map it to the Google group(s).

`locals.tf` file contains the list of predefined custom roles and their permissions.

## Example

```hcl
module "nhi-nci-project-factory-a" {
  source             = "../../modules/nhi-nci/project-factory"

  billing_account_id = "<Billing Account Id>"
  root_node          = "<Folder or Org Id>"
  prefix             = "nhi-nci"
  project_id         = "test-project-a"
  custom_roles       =  {
    "custom_project_owner"  = ["group:nhi-nci-poc-project-a-owner@farrukh.joonix.net"],
    "custom_project_viewer" = ["group:nhi-nci-poc-project-a-viewer@farrukh.joonix.net"]
  }
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
| *custom_roles* | Optional IAM custom role(s) bindings for the project in {CUSTOM_ROLE => [MEMBERS]} format. | `map(list(string))` |  | `{}` |
| *iam* | Optional IAM bindings for the project in {ROLE => [MEMBERS]} format. | `map(list(string))`|  | `{}`</code> |
| *project_services* | Optional Service APIs to be enabled in projects. | `list(string)`|  | `[]`|

## Outputs

| name | description | sensitive |
|---|---|:---:|
| project | Project name and id that was created. |  |
<!-- END TFDOC -->
