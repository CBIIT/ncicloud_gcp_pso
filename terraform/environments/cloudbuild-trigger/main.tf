locals {
    repo_name           = "nci-image-factory-poc2"
    image_family        = "nci-image-family-poc"
    image_name          = "nci-debian-poc-image"
    network_project_id  = "nci-image-factory-poc2"
    vpc_name            = "default"
    subnet_name         = "default"
    gcp_zone            = "us-central1-b"
    project_id          = "nci-image-factory-poc2"
    source_image_family = "debian-10"
    ssh_user            = "packer"
    omit_external_ip    = false
    use_internal_ip     = false
}

resource "google_cloudbuild_trigger" "image-factory-trigger" {
  name    = "${local.repo_name}-trigger"
  project = local.project_id

  trigger_template {
    repo_name   = local.repo_name
    branch_name = ".*"
  }

  substitutions = {
    _IMAGE_FAMILY        = local.image_family
    _IMAGE_NAME          = local.image_name
    _NETWORK_PROJECT_ID  = local.network_project_id
    _NETWORK             = local.vpc_name
    _SUBNETWORK          = local.subnet_name
    _ZONE                = local.gcp_zone
    _PROJECT_ID          = local.project_id
    _SOURCE_IMAGE_FAMILY = local.source_image_family
    _SSH_USER            = local.ssh_user
    _OMIT_EXTERNAL_IP    = local.omit_external_ip
    _USE_INTERNAL_IP     = local.use_internal_ip
  }

  filename = "cloudbuild.yaml"
}