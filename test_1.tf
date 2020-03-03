provider "aws" {
    access_key = "AKIAXNZVCQ5HENPY225C"
    secret_key = "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"
    region = "eu-west-1"
}
resource "aws_vpc" "testvpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "test"
    }
}
resource "aws_internet_gateway" "test" {
    vpc_id = "${aws_vpc.testvpc.id}"

}
resource "aws_route_table" "eu-west-1a-public" {
    vpc_id = "${aws_vpc.testvpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.test.id}"
    }

    tags = {
        Name = "Public Subnet"
    }
}
resource "aws_subnet" "testsubnet" {
    vpc_id = "${aws_vpc.testvpc.id}"

    cidr_block = "10.0.0.0/16"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "test"
    }
}
resource "aws_lb" "test" {
  name               = "test"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.testsubnet.id}"]

  enable_deletion_protection = true

  tags = {
    Environment = "test"
  }
}
resource "aws_instance" "test1" {
    ami = "ami-0ff760d16d9497662"
    instance_type = "t2.micro"
    key_name = "test"
}
resource "aws_instance" "test2" {
    ami = "ami-0ff760d16d9497662"
    instance_type = "t2.micro"
    key_name = "test"
}
terraform {
  backend "s3" {
    bucket = "bogdantest"
    key    = "bogdantest/"
    region = "eu-west-1"
  }
}