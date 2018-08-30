#we are going to use AWS as a cloud provider and the region is us-east-1
provider "aws"{
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"
}
#for each provider, we can create different kinds of resources
#aws_instance: type of resource
#ec2_instance_example:identifier for the resource within Terraform context
#ubuntu includes busybox. nohup:leave webserver run after the script is finished. 
#& at the end allows the script to exit without getting blocked by webserver
#<<-EOF” and “EOF: terraform's heredoc syntax, allow creating multiline strings with no \n
#aws_security_group.ec2_sg.id resource_type.resource_name.resource_attribute
resource "aws_instance" "ec2_instance_example" {
    ami = "ami-2d39803a"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.ec2_sg.id}"]
    user_data = <<-EOF
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p "${var.http_port}" &
                EOF
    tags {
        Name = "terraform_ec2_example"
    }
}

resource "aws_security_group" "ec2_sg" {
    name = "ec2_example_sg"
    ingress {
        from_port = "${var.http_port}"
        to_port = "${var.http_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
resource "aws_eip" "ec2_public_ip" {
    instance = "${aws_instance.ec2_instance_example.id}"
    vpc = true
}
variable "http_port" {
  description = "port which is used to serve HTTP request"
  default = 8080
}
