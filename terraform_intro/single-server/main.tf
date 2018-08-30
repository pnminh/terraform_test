#we are going to use AWS as a cloud provider and the region is us-east-1
provider "aws"{
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"
}
#for each provider, we can create different kinds of resources
#aws_instance: type of resource
#ec2_instance_example:identifier for the resource within Terraform context
resource "aws_instance" "ec2_instance_example" {
    ami = "ami-2d39803a"
    instance_type = "t2.micro"
    tags {
        Name = "terraform_ec2_example"
    }
}
