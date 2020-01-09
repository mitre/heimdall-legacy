# DockerFile modification and using packer and terraform to build out AWS instance

* There is a DockerFile, that will be run which will create a Jenkins Docker image with Inspec, Packer and Terraform installed. 

* You can modify the base_ami.json that is included to include your AWS creds, VPC information, and other information that are in the template.  
Provisioners allow you to provisions the AMI you are building with commands to install, update or configure the machine before it is committed to your EBS store. 
Builders are where you configure the image you are creating settings. 
More information is located here about builders and provisioners: https://www.packer.io/docs/index.html

*  This base_ami.json will be run by the DockerFile, and if everything is configured correctly, it will build an AMI image in your AWS EBS volume store. 
This AMI will be used in creating an EC2 instance in AWS.

* The terraform.tf file will be used to create an AWS EC2 instance, which will be built off the AMI we created with the Packer script. 
The same information that was required for Packer will be required for Terraform in regards to AWS account information. Once you have the terraform.tf file configured properly, the DockerFile will copy it to the docker image.
Here it will run through the init and apply phase. Once these phases are complete, it will build an EC2 instance, and start it. 
There are many configurations for Terraform. 
You can read about them here: https://learn.hashicorp.com/terraform/getting-started/build

* Once the EC2 instance is built, you can scan the instance with InSpec that is installed in the docker image, and you can interact with the box directly by starting an interactive terminal session and running the standard inspec exec command.
Inspec documentation can be found here for running a command: https://www.inspec.io/docs/reference/cli/