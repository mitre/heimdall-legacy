#Create ALB
resource "aws_alb" "main" {
  name            = "heimdall-alb-${random_id.build.hex}"
  subnets         = ["${aws_subnet.heimdall_main_subnet.id}", "${aws_subnet.heimdall_backup_subnet.id}"]
  security_groups = ["${aws_security_group.mitre_web_sg.id}", "${aws_security_group.mitre_base_sg.id}", "${aws_default_security_group.default.id}"]
}
output "lb_address" {
  value = "${aws_alb.main.dns_name}"
}

resource "aws_alb_target_group" "app" {
  name        = "heimdal-alb-targetgroup-${random_id.build.hex}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.heimdall_vpc.id
  target_type = "ip"

  health_check {          # This health check is based on the start up and response time of Heimdall
    healthy_threshold   = 2    
    unhealthy_threshold = 5    
    timeout             = 5 
    interval            = 60
    path                = "/health_check"    
    port                = 80
  }

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end_tls" {
  load_balancer_arn = aws_alb.main.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "front_end_redir" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
