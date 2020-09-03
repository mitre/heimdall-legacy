# ROLES #################################

resource "aws_iam_role" "ECS_execution_agent_1" {
  name = "${var.proj_name}_ECS_execution_agent_1_${random_id.build.hex}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# ATTACH ECS ROLE ########################################

resource "aws_iam_role_policy_attachment" "ECSTaskExec-attach" {
  role       = aws_iam_role.ECS_execution_agent_1.name
  policy_arn = var.AmazonECSTaskExecutionRolePolicy_arn
}
resource "aws_iam_role_policy_attachment" "RDSFullAccess-attach" {
  role       = aws_iam_role.ECS_execution_agent_1.name
  policy_arn = var.AmazonRDSDataFullAccess_arn
}

# SECRETS AND TOKENS #####################################

resource "random_password" "db_master_pass" {
  length            = 128
  special           = var.include_special_db_pass
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}

output "db_password" {
  value = "${var.display_db_pass ? random_password.db_master_pass.result : null }"
  description = "db password"
}

resource "aws_secretsmanager_secret" "db-pass" {
  name = "${var.proj_name}_db-pass-terraform-${random_id.build.hex}"

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

resource "aws_secretsmanager_secret_version" "db-pass-ver" {
  secret_id     = aws_secretsmanager_secret.db-pass.id
  secret_string = random_password.db_master_pass.result
}

# CERTIFICATES FOR SSL #####################################

# Certificate generation requires DNS validation among other steps
# which is not recommended for terraform at this time.
