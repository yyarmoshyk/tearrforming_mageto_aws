variable "userdata_file" {}
variable "project_name" {}
variable "domains" {}
variable "instance_type" {}
variable "region" {}
variable "infrastructure_ver" {}

locals {
  public_ingress_ports = ["80","443","22"]
  public_egress_ports  = ["80","443"]
}
