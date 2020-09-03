#Create RDS Parameter Group
resource "aws_db_parameter_group" "heimdall_pg" {
  name   = "${var.proj_name}-heimdall-pg-${random_id.build.hex}"
  family = "postgres12"

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

#Create RDS Subnet Group
resource "aws_db_subnet_group" "heimdall_subg" {
  name       = "${var.proj_name}-heimdall-subnet-group-${random_id.build.hex}"
  subnet_ids = ["${aws_subnet.heimdall_rds_subnet_a.id}", "${aws_subnet.heimdall_rds_subnet_b.id}"] 

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

#Create RDS
resource "aws_db_instance" "heimdall_db" {
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  engine                = "postgres"
  engine_version        = "12.2"
  instance_class        = var.instance_class
  name                  = "${var.proj_name}_heimdall_postgres_production"
  username              = "postgres"
  password              = random_password.db_master_pass.result
  parameter_group_name  = aws_db_parameter_group.heimdall_pg.name
  db_subnet_group_name  = aws_db_subnet_group.heimdall_subg.id
  skip_final_snapshot   = true
  vpc_security_group_ids = ["${aws_security_group.mitre_web_sg.id}", "${aws_security_group.mitre_base_sg.id}", "${aws_default_security_group.default.id}"]

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}
