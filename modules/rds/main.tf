########################
# DB Subnet Group
########################
resource "aws_db_subnet_group" "this" {
  name       = "wp-${var.environment}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name        = "wp-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

###########################
# RDS Security Group
##########################
resource "aws_security_group" "db" {
  name        = "wp-${var.environment}-db-sg"
  description = "Allow MySQL access from application layer"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "wp-${var.environment}-db-sg"
    Environment = var.environment
  }
}

########################
# RDS Instance
########################
resource "aws_db_instance" "this" {
  identifier             = "wp-${var.environment}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]

  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = {
    Name        = "wp-${var.environment}-mysql"
    Environment = var.environment
  }
}
