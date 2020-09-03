# Terraform Config ##################################

terraform {
  required_version = ">= 0.12.7"

  required_providers {
    aws = ">= 2.68"
  }
}

data "aws_region" "current" {}

#Random Id to make resources unique to this deployment
resource "random_id" "build" {
  byte_length = 2
}
