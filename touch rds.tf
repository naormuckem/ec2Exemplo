# RDS Instance Configuration
resource "aws_db_instance" "studentdb" {
  identifier     = "studentdb-instance"
  engine         = "postgres"
  engine_version = "13.13"
  instance_class = "db.t2.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type         = "gp2"
  
  db_name  = "studentdb"
  username = "student"
  password = var.db_password
  
  publicly_accessible = true
  skip_final_snapshot = true
  
  # Security Group for RDS
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  tags = {
    Name = "StudentDB RDS Instance"
    Environment = "development"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"
  description = "Security group for RDS instance"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "PostgreSQL access"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }
  
  tags = {
    Name = "RDS Security Group"
  }
}