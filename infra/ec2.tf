# ec2.tf - EC2 Instances (Cheaper Option)

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_role" "ec2" {
  count = var.use_ec2_instead_of_eks ? 1 : 0
  name  = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  count      = var.use_ec2_instead_of_eks ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2[0].name
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.use_ec2_instead_of_eks ? 1 : 0
  name  = "${var.project_name}-${var.environment}-ec2-profile"
  role  = aws_iam_role.ec2[0].name
}

resource "aws_instance" "app" {
  count                  = var.use_ec2_instead_of_eks ? var.ec2_instance_count : 0
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public[count.index % length(aws_subnet.public)].id
  vpc_security_group_ids = [aws_security_group.ec2[0].id]
  iam_instance_profile   = aws_iam_instance_profile.ec2[0].name
  key_name               = var.ssh_key_name != "" ? var.ssh_key_name : null

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              yum install -y git
              EOF

  tags = {
    Name = "${var.project_name}-${var.environment}-app-${count.index + 1}"
  }
}

resource "aws_eip" "ec2" {
  count    = var.use_ec2_instead_of_eks ? var.ec2_instance_count : 0
  instance = aws_instance.app[count.index].id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-eip-${count.index + 1}"
  }
}