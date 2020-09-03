# Heimdall Terraform

Terraform assets used to deploy the latest Heimdall Docker image onto Fargate in AWS.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

## Prerequisites

The following environments, technologies and projects are needed:
* AWS Account with Programmatic Access
* Terraform
* Heimdall Terraform MITRE GitLab Repository

## Installing

Execute the following steps

* Validate that your AWS profile is configured locally on your desktop. [Setup AWS Profile Reference](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
* Validate that Terraform is installed.

#### Windows:
```
PS C:\ terraform -v
```

#### Linux:
```
$ terraform -v
```

* The output of the command above should look similar to the example below. [Install Terraform Reference](https://learn.hashicorp.com/terraform/getting-started/install.html)

```
Terraform v0.12.24
```

# Deployment

* To deploy Heimdall, using a terminal (PowerShell, CMD, Bash, etc.) change to the _terraform_ directory and create a provider. While this is not necessary, it is HIGHLY recommended. Use the *provider.tf.sample* as a template. This can be done by copying or renaming the *provider.tf.sample* into a new file called *provider.tf*. Change the provider configuration to your specific AWS environment or profile. [Setting up the AWS Terraform Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

Then execute the init, plan, and apply commands. You will be prompted for four required variables:

## Required Inputs
These inputs are required, (optional can be found at the bottom of this page, [here](#variables)) they are, in order of prompt:

* [ARN of the domain certificate](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html) - This is the SSL certificate to enable encrypted HTTP connections to Heimdall. Click [here](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html) for instructions on how to make this.
* Display DB Password - Whether or not to display the DB password for Heimdall. Unless you plan on connecting to the database, it is best to set this as `false`.
* [Heimdall Image](https://hub.docker.com/r/mitre/heimdall) - This is the image reference for Heimdall. You can use any, including your own, but the Docker Official one from MITRE is recommended.
* Project Name - The project name displayed in tags and logs for your project.
* CIDR /24 prefix - The first 16 digits of your desired CIDR block for the Heimdall deployment, Ex: `172.198`.
* Your Name - The contact name displayed in tags and logs for your project.

#### Windows
```
PS C:\ terraform init
PS C:\ terraform plan
PS C:\ terraform apply
```

#### Linux
```
$ terraform init
$ terraform plan
$ terraform apply
```

* After Terraform has successfully deployed Heimdall, the DNS entry for Heimdall's Appliaction Load Balancer will be printed to the stdout of where the `terraform apply` was run. It can also be retrieved from the AWS console and [CLI](https://docs.aws.amazon.com/cli/latest/reference/elb/describe-load-balancers.html) This DNS entry will be used to access the deployed Heimdall appliaction. It is best to create a DNS record that forwards your desired domain URL to this load balancer address. Click [here](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-elb-load-balancer.html) for how to do this in Route53.

* To destroy Heimdall.. using a terminal (PowerShell, CMD, Bash, etc.) change to the _heimdall-terraform_ directory and execute the destroy command. You will be prompted for the same four variables, you do NOT need to enter them during the destroy:

#### Windows
```
PS C:\ terraform destroy
```

#### Linux
```
$ terraform destroy
```

## Built With

* [Terraform](https://www.terraform.io/) - Infrastructure as Code
* [Heimdall](https://github.com/mitre/heimdall) - Heimdall Open Source Project.
* [AWS](https://console.aws.amazon.com/) - AWS Environment

## Potential Improvements
* Add the domain entry and certificate generation to terraform
    * Current version of terraform (0.13) does not do this well
* Add tags to aws_ecs_service
    * Upgrade to latest AWS resource ID to do this. Click [here](https://aws.amazon.com/blogs/compute/migrating-your-amazon-ecs-deployment-to-the-new-arn-and-resource-id-format-2/) for more info on this.

## Authors

* **[Johnathan White](https://github.com/jrwhite17)** - *Initial work*
* **[Armaan Mehta](https://github.com/amehta-mitre)** - *Subsequent work*

# Development Notes

The `security_groups.tf` contains three security groups defined by MITRE infosec for use in MITRE projects. These are required for most MITRE projects and are therefore hardcoded. Feel free to replace them when deploying to other environments.

The VPC in this project creates four subnets, two for Heimdall and two for the RDS instance. This can be replaced by public VPC modules, however they are often overkill for Heimdalls deployment requirements.

To deploy this as a module, please see the Terraform Modules info [here](https://www.terraform.io/docs/configuration/modules.html)

# Variables

#### Required
* `your_name`: **String** Name of the contact tag for all AWS resources
* `proj_name`: **String** Name of the project in which Heimdall is being deployed
* `heimdall_image`: **String** Heimdall image repo url and version. Ex: *mitre/heimdall:latest*
* `vpc_cidr_first_16`: **String** The first 16 digits of a /24 CIDR, in the format of {1-255}.{1-255} Ex: *172.18*
* `display_db_pass`: **Bool** Should terraform output the generated heimdall database password to stdout?
* `certificate_arn`: **String** ARN of the domain certificate for Heimdall. See [this](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)

#### Optional
* `RAILS_SERVE_STATIC_FILES`: **Bool** Whether rails serves static files in its deployment. Default *true*
* `RAILS_ENV`: **String** Environment tag for rails deployment. Default production
* `HEIMDALL_RELATIVE_URL_ROOT`: **String** Relative root url for heimdall deployment location. Default empty
* `DISABLE_SPRING`: **Bool** Disable springboot in Heimdall deployment? Default *false*
* `RAILS_LOG_TO_STDOUT`: **Bool** Display rails logs to stdout for viewing in AWS cloudwatch/ECS logs? Default *true*
* `AmazonECSTaskExecutionRolePolicy_arn`: **String** The ARN for the ECS task execution role policy. Change this from the default if working in non standard region (govcloud)
* `AmazonRDSDataFullAccess_arn`: **String** The ARN for the RDS full access role policy. Change this from the default if working in non standard region (govcloud)
* `include_special_db_pass`: **Bool** Whether or not to include special characters in the db passcode, default true
* `allocated_storage`: **Integer** Initial size of database for Heimdall in GiB
* `max_allocated_storage`: **Integer** Maximum size of database for Heimdall in GiB
* `storage_type`: **String** Storage type for RDS storage, best to leave this as default gp2, see [this](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#Concepts.Storage)
* `instance_class`: **String** Size and type of instance to run RDS. See [this](https://aws.amazon.com/rds/instance-types/)
