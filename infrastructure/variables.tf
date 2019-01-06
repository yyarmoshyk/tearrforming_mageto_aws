variable "userdata_file" {}
variable "project_name" {}
variable "domains" {}
variable "instance_type" {}

locals {
  public_ingress_ports = ["80","443","22"]
  public_egress_ports  = ["80","443"]
}
