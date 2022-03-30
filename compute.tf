
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "vm1" {
  name                      = "vm1-${var.instance_id}"
  machine_type              = var.gcp_vms_size
  zone                      = data.google_compute_zones.available.names[0]
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = var.gcp_os_r
    }
  }

  metadata = {
    serial-port-logging-enable = "TRUE"
    serial-port-enable         = true
    startup-script-url = "https://raw.githubusercontent.com/ibenrodriguez/iac-demo-gcp/main/init_os_redhat_deps.sh"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet1.name
    access_config {
     // Include this section to give the VM an external ip address
   }
  }
}

# Backend service
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
resource "google_compute_backend_service" "website" {
  name                  = "backend-service-${var.instance_id}"
  description           = "backend-service-${var.instance_id}"
  protocol              = "HTTP"
  port_name             = "http"
 # port_name - Name of backend port. The same name should appear in the instance groups referenced by this service.  
  load_balancing_scheme = "EXTERNAL"
  enable_cdn            = false
  timeout_sec           = 10
  security_policy       = google_compute_security_policy.security-policy-1.id
 # custom_request_headers   = ["X-Client-Geo-Location: {client_region_subdivision}, {client_city}"]
 # custom_response_headers  = ["X-Cache-Hit: {cdn_cache_status}"]
  health_checks = [google_compute_health_check.health.id]

  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow-tcp" {
  name    = "allow-tcp-armor-firewall-${var.instance_id}"
  network = google_compute_network.gcp-network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
    log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow-ssh" {
  name      = "allow-ssh-firewall-${var.instance_id}"
  network   = google_compute_network.gcp-network.id
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]

    log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
resource "google_compute_firewall" "default-allow-health-check" {
  name          = "default-allow-health-check"
  description   = "default-allow-health-check"
  direction     = "INGRESS"
  network       = google_compute_network.gcp-network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
#    ports    = ["22","80","443"]

  }
  target_tags = ["allow-health-check","http-server"]
    log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

/* resource "google_compute_firewall" "allow-ssh-eg" {
  name      = "allow-ssh-firewall-eg-${var.instance_id}"
  description      = "allow-ssh-firewall-eg-${var.instance_id}"

  network   = google_compute_network.gcp-network.id
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
} */
resource "google_compute_firewall" "default-eg" {
  name          = "allow-tcp-armor-eg-firewall"
  description   = "allow-tcp-armor-eg-firewall"

  direction     = "EGRESS"
  network       = google_compute_network.gcp-network.id
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["allow-health-check","http-server"]
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_http_health_check

resource "google_compute_health_check" "health" {
  check_interval_sec = "5"
  healthy_threshold  = "2"

  name          = "tcp-http-health-check-${var.instance_id}"
  description   = "tcp-http-health-check-${var.instance_id}"

  tcp_health_check {
    port         = "80"
    proxy_header = "NONE"
 }

#http_health_check {
#   request_path = "/"
#    port         = "80"
#}
# https://cloud.google.com/load-balancing/docs/https/ext-http-lb-tf-module-examples
#        log_config = {
#        enable      = true
#        sample_rate = 1.0
#      }
  timeout_sec         = "5"
  unhealthy_threshold = "2"
}



# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
resource "google_compute_global_forwarding_rule" "default" {
  name       = "armor-rule-${var.instance_id}"
  target     = google_compute_target_http_proxy.default.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "armor-proxy-${var.instance_id}"
  url_map = google_compute_url_map.default.id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
resource "google_compute_url_map" "default" {
  name            = "armor-url-map-${var.instance_id}"
  default_service = google_compute_backend_service.website.id

  # host_rule {
  #   hosts        = ["*"]
  #   path_matcher = "allpaths"
  # }

  # path_matcher {
  #   name            = "allpaths"
  #   default_service = google_compute_backend_service.website.self_link

  #   path_rule {
  #     paths   = ["/*"]
  #     service = google_compute_backend_service.website.self_link
  #   }
  # }
}