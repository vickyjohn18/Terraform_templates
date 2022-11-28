provider "aws" {
    access_key = " Here give the access key of aws account"
    secret_key = "Here give the secret key of aws account"
    region = "ap-south-1"  
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "publicsubnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      "Name" = "PublicSubnet"
    }
  
}
resource "aws_subnet" "privatesubnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    tags = {
      "Name" = "PrivateSubnet"
    }
  
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      "Name" = "MyInternetGateway"
    }
  
}

resource "aws_eip" "EIP" {
    vpc = true
}
resource "aws_nat_gateway" "mynat" {
    allocation_id = aws_eip.EIP.id
    subnet_id = aws_subnet.publicsubnet.id
    tags = {
    Name = "mynat"
  }
}

resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.myvpc.id
    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IG.id
    }
    tags = {
      "Name" = "PublicRT"
    } 
}
resource "aws_route_table_association" "PubRTassociation" {
    subnet_id = aws_subnet.publicsubnet.id
    route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table" "privateRT" {
    vpc_id = aws_vpc.myvpc.id
    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.mynat.id
    }
    tags = {
      "Name" = "PrivateRT"
    } 
}
resource "aws_route_table_association" "PrvtRTassociation" {
    subnet_id = aws_subnet.privatesubnet.id
    route_table_id = aws_route_table.privateRT.id
}