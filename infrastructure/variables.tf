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

####
# RDS variables
####
variable "db_password" {}
variable "num_rds_instances" {
  default = "1"
}
variable "rds_instance_class" {
  default = "db.t2.small"
}
