/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  image_name = "${var.image_name}-${formatdate("MM-DD-YY-hh-mm-ss", timestamp())}"
}

source "googlecompute" "gce-example" {
  project_id          = var.project_id
  source_image_family = var.source_image_family
  ssh_username        = var.ssh_username
  zone                = var.zone
  image_name          = local.image_name
  image_family        = var.image_family
  network             = var.network
  subnetwork          = var.subnetwork
  network_project_id  = var.network_project_id
  omit_external_ip    = var.omit_external_ip
  use_internal_ip     = var.use_internal_ip
}

build {
  sources = ["sources.googlecompute.gce-example"]

# Note: Below provisioner is just used to demonstrate how a file provisioner can be used.
#       It's not recommended to deploy application code with image building process.
  provisioner "file" {
    source      = "./index.html"
    destination = "/tmp/index.html"
  }
  provisioner "shell" {
    inline = [
      "sudo apt-get update -qq",
      "sudo apt-get upgrade -qq",
      "sudo apt-get install -qq apache2",
      "sudo cp /tmp/index.html /var/www/html/index.html"
    ]
  }
}