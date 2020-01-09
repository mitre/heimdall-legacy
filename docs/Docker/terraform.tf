provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "" //AMI ID that was created with PACKER
  instance_type = "t2.micro" //Instance type that you would like to use, I am on free tier, so using this. 
}