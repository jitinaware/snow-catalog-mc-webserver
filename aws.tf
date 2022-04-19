locals {
  # AWS Resources
  vpc_id              = data.terraform_remote_state.backend.outputs.aws_vpc_id
  vpc_pubsubnet_id    = data.terraform_remote_state.backend.outputs.aws_public_subnet_ids[0]
  vpc_pubsub_cidrs    = data.terraform_remote_state.backend.outputs.aws_public_sub_cidrs[0]

  az_subnet_cidr      = data.terraform_remote_state.backend.outputs.az_cidr
}

resource "aws_security_group" "sgext1" {
  name = "sgext1"
  description = "External Traffic"
  vpc_id = local.vpc_id
  

  egress = [
    {
      cidr_blocks      = [ var.aws_allow_cidr_range, ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = [ ]
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ var.aws_allow_cidr_range, ]
     description      = "ssh rule"
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_security_group" "sgall" {
  description = "SG for all Traffic"
  vpc_id = local.vpc_id

  egress = [
    {
      cidr_blocks      = [  #local.vpc_privsub_cidrs, 
                            #local.az_privsubnet_cidrs,
                            local.vpc_pubsub_cidrs, 
                          ]
      description      = "All traffic"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [  #local.vpc_privsub_cidrs, 
                            #local.az_privsubnet_cidrs,
                            local.vpc_pubsub_cidrs, 
                          ]
     description      = "All traffic"
     from_port        = 0
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "-1"
     security_groups  = []
     self             = false
     to_port          = 0
  }
  ]
}


resource "aws_instance" "awsvm" {
  ami           = "ami-00f8e2c955f7ffa9b" # us-east-2
  instance_type = "t2.micro"
  subnet_id = local.vpc_pubsubnet_id
  #private_dns = "consul1"

  key_name = var.aws_keyname

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 40
  }
  tags = {
    Name = "webserver"
  }

  vpc_security_group_ids = [ aws_security_group.sgext1.id, aws_security_group.sgall.id ]
}

