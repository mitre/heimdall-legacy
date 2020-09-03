# default security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.heimdall_vpc.id

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# A security group with accessible via the web
resource "aws_security_group" "mitre_web_sg" {
  name        = "mitre_web_sg"
  description = "mitre web access sg, includes both gatekeepers and vpns, based on f8e0"
  vpc_id      = aws_vpc.heimdall_vpc.id

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
  
  # INGRESSES ####
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["128.29.43.0/30", "129.83.31.0/30", "192.80.55.64/27", "192.160.51.64/27"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["128.29.43.0/30", "129.83.31.0/30", "192.80.55.64/27", "192.160.51.64/27"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["192.160.51.64/27", "192.80.55.64/27", "128.29.43.0/30", "129.83.31.0/30"]
  }
  ingress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["192.160.51.64/27", "128.29.43.0/30", "192.80.55.64/27", "129.83.31.0/30"]
  }

  # EGRESSES ####
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["127.0.0.1/32"]
  }
}

# A security group with ports 80, 8080, and 8443 open
resource "aws_security_group" "mitre_base_sg" {
  name        = "mitre_base_sg"
  description = "mitre base access, includes mitre VPCs and core services, based on c10d"
  vpc_id      = aws_vpc.heimdall_vpc.id

  tags = {
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }

  # INGRESSES ####
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.202.1.73/32"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.160.51.64/27", "10.202.1.6/32", "10.202.1.214/32", "192.80.55.64/27"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["192.160.51.64/27", "10.202.1.6/32", "10.202.1.214/32", "192.80.55.64/27"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.202.1.71/32"]
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.202.1.71/32", "192.80.55.64/27", "10.202.1.6/32", "10.202.1.214/32", "192.160.51.64/27"]
  }

  # EGRESSES ####
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["10.90.255.0/25", "10.202.1.215/32"]
  }
  egress {
    from_port   = 9997
    to_port     = 9997
    protocol    = "tcp"
    cidr_blocks = ["10.202.0.113/32"]
  }
  egress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["10.202.0.113/32"]
  }
  egress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["10.202.1.6/32"]
  }
  egress {
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["10.202.0.113/32"]
  }
  egress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.202.0.113/32", "10.90.255.0/25", "10.202.1.6/32", "10.202.1.215/32"]
  }
}
