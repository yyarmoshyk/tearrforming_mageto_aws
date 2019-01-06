variable "region" {
  default = "us-east-1"
}

variable "infrastructure_ver" {
  default = ""
}

module "test_project" {
  source        = "./infrastructure/"
  project_name  = "magento-test"
  instance_type = "t2.nano"
  domains       = "example1.com,example2.com"
  userdata_file = "files/userdata.sh"
  region        = "${var.region}"
  infrastructure_ver = "${var.infrastructure_ver}"
}
