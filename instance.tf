data "aws_ami" "amzn-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  owners = ["137112412989"] #AWS
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc-west.vpc_id

  ingress {
    description = "Allow SSH Connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   ingress {
  #     description = "Allow port on 8080"
  #     from_port   = 8080
  #     to_port     = 8080
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
}

resource "aws_security_group" "egress-all" {
  name   = "egress-all"
  vpc_id = module.vpc-west.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "infra-master" {
  key_name   = "infra-master-key"
  public_key = var.authorized_key
}

# resource "aws_instance" "bastion-host" {
#   ami             = data.aws_ami.amzn-ami.id
#   instance_type   = "t3.micro"
#   security_groups = [aws_security_group.allow_ssh.id, aws_security_group.egress-all.id]
#   subnet_id       = module.vpc-west.public_subnets[0]
#   key_name        = aws_key_pair.infra-master.id
# }
# 
# resource "aws_eip" "bastion-eip" {
#   vpc      = true
#   instance = aws_instance.bastion-host.id
# 
#   tags = {
#     Assignment = aws_instance.bastion-host.id
#     Comment    = "Managed by Terraform"
#   }
# }


variable authorized_key {
  description = "The public ssh rsa key you generated"
}
