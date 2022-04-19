variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
}

variable "GCP_SA_IAC" {
  description = "GCP Service Account"
  type        = string
}

variable "gcp_subnet1" {
  default = "10.0.0.0/24"
  type    = string
}

variable "gcp_subnet2" {
  default = "10.0.10.0/24"
  type    = string
}

variable "gcp_subnet3" {
  default = "10.0.20.0/24"
  type    = string
}

variable "gcp_subnet4" {
  default = "10.0.30.0/24"
  type    = string
}

variable "gcp_vms_size" {
  type    = string
}
variable "gcp_vm_os" {
  default = "rhel-cloud/rhel-7"
  type    = string
}
variable "gcp_vm_username" {
  default = "iben"
  type    = string
}

variable "instance_id" {
  default = "test-vzxy-01"
  type    = string
}
