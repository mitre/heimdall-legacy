# Password variable for task definition
locals {
  DATABASE_URL = join("", ["postgres://${aws_db_instance.heimdall_db.username}:", urlencode(aws_db_instance.heimdall_db.password), "@${aws_db_instance.heimdall_db.endpoint}/${aws_db_instance.heimdall_db.name}"])
}

#Create CloudWatch Logging Gorup
resource "aws_cloudwatch_log_group" "heimdall_cwatch" {
  name = "${var.proj_name}_heimdall-terraform-${random_id.build.hex}"

  tags = {
    Name   = "${var.proj_name}-heimdall-cw-loggroup"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
    Application = "heimdall"
  }
}

#Create ECS Cluster
resource "aws_ecs_cluster" "heimdall_cluster" {
  name = "${var.proj_name}_heimdall-${random_id.build.hex}"

  tags = {
    Name   = "${var.proj_name}-heimdall-ECS-cluster"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}
data "aws_ecs_cluster" "heimdall_cluster" {
  cluster_name = "${var.proj_name}_heimdall-${random_id.build.hex}"

  depends_on = [
    aws_ecs_cluster.heimdall_cluster,
  ]
}

resource "aws_ecs_task_definition" "heimdall_task_definition" {
  family                   = "${var.proj_name}_heimdall-${random_id.build.hex}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  task_role_arn            = aws_iam_role.ECS_execution_agent_1.arn
  execution_role_arn       = aws_iam_role.ECS_execution_agent_1.arn

  tags = {
    Name   = "${var.proj_name}-heimdall-task-definition"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
  container_definitions = <<DEFINITION
[
  {
    "cpu": 1024,
    "image": "${var.heimdall_image}",
    "memory": 2048,
    "name": "${var.proj_name}-heimdall-container",
    "healthCheck": {
            "Command": [
                "CMD-SHELL",
                "wget -q --spider http://localhost/ || exit 1"
            ],
            "Interval": 300,
            "Timeout": 60
        },
	"command": ["/bin/sh","-c","rm -f tmp/pids/server.pid && bundle exec rake db:migrate assets:precompile && bundle exec rails s -p 80 -b '0.0.0.0'"],
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80
      }
    ],
	"logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group" : "${aws_cloudwatch_log_group.heimdall_cwatch.name}",
        "awslogs-region": "${data.aws_region.current.name}",
		"awslogs-stream-prefix": "${var.proj_name}-heimdall-container-logs"
      }
    },
	"environment": [
            {
                "Name": "DATABASE_URL",
                "Value": "${local.DATABASE_URL}"
            },
            {
                "Name": "RAILS_SERVE_STATIC_FILES",
                "Value": "${var.RAILS_SERVE_STATIC_FILES}"
            },
            {
                "Name": "RAILS_ENV",
                "Value": "${var.RAILS_ENV}"
            },
            {
                "Name": "HEIMDALL_RELATIVE_URL_ROOT",
                "Value": "${var.HEIMDALL_RELATIVE_URL_ROOT}"
            },
            {
                "Name": "DISABLE_SPRING",
                "Value": "${var.DISABLE_SPRING}"
            },
            {
                "Name": "RAILS_LOG_TO_STDOUT",
                "Value": "${var.RAILS_LOG_TO_STDOUT}"
            }
        ]
    }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name            = "${var.proj_name}-heimdall-service-${random_id.build.hex}"
  cluster         = aws_ecs_cluster.heimdall_cluster.id
  task_definition = aws_ecs_task_definition.heimdall_task_definition.arn
  desired_count   = "2"
  launch_type     = "FARGATE"

  network_configuration {
  security_groups  = ["${aws_security_group.mitre_web_sg.id}", "${aws_security_group.mitre_base_sg.id}", "${aws_default_security_group.default.id}"]
	subnets          = ["${aws_subnet.heimdall_main_subnet.id}"]
	assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "${var.proj_name}-heimdall-container"
    container_port   = "80"
  }

  depends_on = [
    aws_alb_listener.front_end_tls,
  ]

# Add this when the new ARN and resource IDs are used on your AWS accounts
#  tags = {
#    Owner   = "${var.your_name}"
#    Project = "${var.proj_name}"
#  }
}
