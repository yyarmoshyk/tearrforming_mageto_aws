resource "aws_db_subnet_group" "subnet_group" {
  name                = "${var.project_name}-subnetgroup"
  subnet_ids          = ["${data.aws_subnet_ids.private..ids}"]
  tags {
    Name              = "${var.project_name}-subnetgroup"
  }
}

resource "aws_rds_cluster_parameter_group" "parameter_group" {
  name                = "${var.project_name}-parametergroup"
  family              = "aurora-mysql5.7"

  parameter {
    name              = "binlog_format"
    value             = "MIXED"
    apply_method      = "pending-reboot"
  }

  tags {
    Name              = "${var.project_name}-parametergroup"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {

    apply_immediately                         = "false"
    cluster_identifier                        = "${var.project_name}"
    engine                                    = "aurora-mysql"
    engine_version                            = "5.7.12"
    master_username                           = "root"
    master_password                           = "${var.db_password}"
    db_subnet_group_name                      = "${aws_db_subnet_group.subnet_group.name}"
    availability_zones                        = ["${data.aws_subnet.private.*.availability_zone}"]
    vpc_security_group_ids                    = ["${aws_security_group.private.id}"]
    skip_final_snapshot                       = "true"
    backup_retention_period                   = "10"
    preferred_backup_window                   = "10:00-10:30"
    final_snapshot_identifier                 = "${var.project_name}-snapshot-${md5(timestamp())}"
    db_cluster_parameter_group_name           = "${aws_rds_cluster_parameter_group.parameter_group.name}"
    # replication_source_identifier             = "${var.db_replication_source_arn}"


  tags {
    Name              = "${var.project_name}-rds-cluster"
  }

  lifecycle {
        ignore_changes = ["final_snapshot_identifier"]
    }
}

resource "aws_rds_cluster_instance" "cluster_instance" {
    count                       = "${var.num_rds_instances}"
    identifier                  = "${var.project_name}-${format("%02d", count.index+1)}"
    cluster_identifier          = "${aws_rds_cluster.aurora_cluster.id}"
    instance_class              = "${var.rds_instance_class}"
    #allocated_storage           = "${var.db_storage}"
    db_subnet_group_name        = "${aws_db_subnet_group.subnet_group.name}"
    availability_zone           = "${data.aws_subnet.private.*.availability_zone[count.index]}"
    engine                      = "${aws_rds_cluster.aurora_cluster.engine}"
    engine_version              = "${aws_rds_cluster.aurora_cluster.engine_version}"

    tags {
      Name              = "${element(split(",", replace(join(",", data.aws_subnet.private.*.availability_zone), "/([a-z]+-)+/", "")), count.index)}-${var.project_name}-${format("%02d", count.index+1)}"
    }
}
