data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# App EC2 Security Group
resource "aws_security_group" "app" {
  name   = "wp-${var.environment}-app-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp-${var.environment}-app-sg"
  }
}

resource "aws_instance" "app" {
  count         = length(var.subnet_ids)
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index]

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  iam_instance_profile = var.instance_profile_name

  user_data = templatefile("${path.module}/user_data.sh", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    domain_name = var.domain_name
    environment = var.environment
  })

  tags = {
    Name = "wp-${var.environment}-app-${count.index + 1}"
  }
}

###