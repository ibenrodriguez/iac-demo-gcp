# data "template_file" "metadata_startup_script_redhat" {
#   template = "${file("init_os_redhat_deps.sh")}"
# }

# data "template_file" "metadata_startup_script_redhat_apache" {
#   template = "${file("init_os_redhat_deps_apache.sh")}"
# }

# # resource "google_compute_instance" "vm1" {
# #   name         = "vm1-${var.instance_id}"
# #   machine_type = "${var.gcp_vms_size}"
# #   zone         = "${data.google_compute_zones.available.names[0]}"

# #   boot_disk {
# #     initialize_params {
# #       image = "${var.gcp_os_r}"
# #     }
# #   }

# #   metadata_startup_script = "${data.template_file.metadata_startup_script_redhat.rendered}"

# #   network_interface {
# #     subnetwork = "${google_compute_subnetwork.subnet1.name}"
# #   }
# # }

# resource "google_compute_disk" "disk1" {
#   name  = "test-disk"
#   type  = "pd-ssd"
#   zone  = "us-central1-a"
#   labels = {
#     environment = "dev"
#   }
#   physical_block_size_bytes = 4096
# }

# resource "google_compute_attached_disk" "default" {
#   disk     = google_compute_disk.disk1.id
#   instance = google_compute_instance.vm2.id
# }


# resource "google_compute_instance" "vm2" {
#   name         = "vm2-${var.instance_id}"
#   machine_type = "${var.gcp_vms_size}"
#   zone         = "${data.google_compute_zones.available.names[0]}"

#   boot_disk {
#     initialize_params {
#       image = "${var.gcp_os_r}"
#     }
#   }

#   metadata_startup_script = "${data.template_file.metadata_startup_script_redhat_apache.rendered}"



#   network_interface {
#     subnetwork = "${google_compute_subnetwork.subnet3.name}"
#   }

#   lifecycle {
#     ignore_changes = [attached_disk]
#   }

# }

