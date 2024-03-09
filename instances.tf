### Backend Machine
resource "aws_instance" "backend" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.backend.id]
  key_name               = "actions-key"

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "BackendMachine"
  }
}


### Frontend Machine
resource "aws_instance" "frontend" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  key_name               = "actions-key"


  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "FrontendMachine"
  }
}


# MySQL RDS
resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  identifier             = "my-ecommerce-db"
  instance_class         = "db.t3.micro"
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.backend.id] # Allow backend access
  db_subnet_group_name   = aws_db_subnet_group.main.name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "MySQL-RDS"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
}