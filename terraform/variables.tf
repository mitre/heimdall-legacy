# Project Info ##################################

variable "your_name" {
    description = "Name of the contact tag for all AWS resources"
    type    = string
}

variable "proj_name" {
    description = "Name of the project in which Heimdall is being deployed"
    type    = string
}

# Heimdall config and Networking ################

variable "heimdall_image" {
    description = "Heimdall image repo url and version. Ex: mitre/heimdall:latest"
    type = string
}

variable "vpc_cidr_first_16" {
    description = "The first 16 digits of a /24 CIDR, in the format of {1-255}.{1-255} Ex: 172.18"
    type = string
}

variable "RAILS_SERVE_STATIC_FILES" {
    description = "Whether rails serves static files in its deployment. Default true"
    type = bool
    default = true
}

variable "RAILS_ENV" {
    description = "Environment tag for rails deployment. Default production"
    type = string
    default = "production"
}

variable "HEIMDALL_RELATIVE_URL_ROOT" {
    description = "Relative root url for heimdall deployment location. Default empty"
    type = string
    default = ""
}

variable "DISABLE_SPRING" {
    description = "Disable springboot in Heimdall deployment? Default false"
    type = bool
    default = false
}

variable "RAILS_LOG_TO_STDOUT" {
    description = "Display rails logs to stdout for viewing in AWS cloudwatch/ECS logs? Default true"
    type = bool
    default = true
}

# Credentials and Certs #########################

variable "certificate_arn" {
    description = "ARN of the domain certificate for Heimdall. See: https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html"
    type = string
}

variable "AmazonECSTaskExecutionRolePolicy_arn" {
    description = "The ARN for the ECS task execution role policy. Change this from the default if working in non standard region (govcloud)"
    type = string
    default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "AmazonRDSDataFullAccess_arn" {
    description = "The ARN for the RDS full access role policy. Change this from the default if working in non standard region (govcloud)"
    type = string
    default = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}

# Database Config ###############################

variable "display_db_pass" {
    description = "Shouold terraform output the generated heimdall database password to stdout?"
    type = bool
}

variable "include_special_db_pass" {
    description = "Whether or not to include special characters in the db passcode. This requires URI encoding, so the default is false"
    type = bool
    default = true
}

variable "allocated_storage" {
    description = "Initial size of database for Heimdall in GiB"
    type = number
    default = 20
}

variable "max_allocated_storage" {
    description = "Maximum size of database for Heimdall in GiB"
    type = number
    default = 100
}

variable "storage_type" {
    description = "Storage type for RDS storage, best to leave this as default gp2, see: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#Concepts.Storage"
    type = string
    default = "gp2"
}

variable "instance_class" {
    description = "Size and type of instance to run RDS. See: https://aws.amazon.com/rds/instance-types/"
    type = string
    default = "db.t2.micro"
}
