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

resource "google_compute_backend_bucket" "bucket-backend" {
  project     = var.project_id
  name        = "${var.bucket_name}-backend"
  bucket_name = var.bucket_name
  enable_cdn  = var.enable_cdn
}

resource "google_compute_global_forwarding_rule" "rule" {
  project               = var.project_id
  name                  = var.rule_name
  target                = google_compute_target_https_proxy.proxy.id
  port_range            = "443"
  ip_address            = var.ip_address
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_https_proxy" "proxy" {
  project          = var.project_id
  name             = "${var.rule_name}-proxy"
  url_map          = google_compute_url_map.url-map.id
  ssl_certificates = [google_compute_ssl_certificate.tls.id]
}

resource "google_compute_url_map" "url-map" {
  project         = var.project_id
  name            = "${var.rule_name}-url-map"
  default_service = google_compute_backend_bucket.bucket-backend.id
  host_rule {
    hosts        = [var.domain]
    path_matcher = "${var.rule_name}-path-matcher"
  }

  path_matcher {
    name            = "${var.rule_name}-path-matcher"
    default_service = google_compute_backend_bucket.bucket-backend.id
  }
}

data "google_secret_manager_secret_version" "tls-private-key" {
  project = var.project_id
  secret  = var.private-key-secret-name
}

data "google_secret_manager_secret_version" "tls-public-cert" {
  project = var.project_id
  secret  = var.public-cert-secret-name
}

resource "google_compute_ssl_certificate" "tls" {
  project     = var.project_id
  name_prefix = "nic-poc-cert-"
  private_key = data.google_secret_manager_secret_version.tls-private-key.secret_data
  certificate = data.google_secret_manager_secret_version.tls-public-cert.secret_data

  lifecycle {
    create_before_destroy = true
  }
}