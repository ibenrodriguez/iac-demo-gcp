# Instance template
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template
resource "google_compute_instance_template" "vm2" {
  name         = "inst-tmpl-${var.instance_id}"
  description  = "instance template ${var.instance_id}"
  machine_type = var.gcp_vms_size
  tags         = ["http-server","allow-health-check","http"]

  network_interface {
    network    = google_compute_network.gcp-network.id
    subnetwork = google_compute_subnetwork.subnet3.id

  }
  disk {
    source_image = var.gcp_os_r
    auto_delete  = true
    boot         = true
  }

  # install apache and serve a simple web page
  metadata = {
    serial-port-enable = true
    serial-port-logging-enable = "TRUE"
    startup-script =  "https://raw.githubusercontent.com/ibenrodriguez/iac-demo-gcp/main/init_os_redhat_deps_apache.sh"
  }
  lifecycle {
    create_before_destroy = true
  }
}
# resource "google_compute_health_check" "autohealing" {
#   name                = "autohealing-health-check"
#   check_interval_sec  = 5
#   timeout_sec         = 5
#   healthy_threshold   = 2
#   unhealthy_threshold = 10 # 50 seconds
#  http_health_check {
#    request_path = "/"
#    port         = "80"
#  }
#}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager
resource "google_compute_instance_group_manager" "default" {
  name          = "mig-${var.instance_id}"
  description   = "mig-${var.instance_id}"

  zone   = data.google_compute_zones.available.names[0]

  version {
    instance_template = google_compute_instance_template.vm2.id
    name              = "primary"
  }
  named_port {
    name = "http"
    port = 80
  }
  base_instance_name = "vm"
  target_size        = 1
  
#    auto_healing_policies {
#    health_check      = google_compute_health_check.autohealing.id
#    initial_delay_sec = 300
#  }

}
