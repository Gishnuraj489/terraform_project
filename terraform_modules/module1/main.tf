terraform {
  required_version = ">= 0.12"
}

resource "aws_vpc" "vpc-gems" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-gems"
  }
}   

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc-gems.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Change to your desired AZ

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "igw-gems" {
  vpc_id = aws_vpc.vpc-gems.id

  tags = {
    Name = "igw-gems"
  }
}       

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc-gems.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-gems.id
    }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "gems_sg" {
  name        = "gems_sg"
  description = "Security group for gems application"
  vpc_id      = aws_vpc.vpc-gems.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Allow HTTP traffic from anywhere
  }
  ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }   

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "gem2_key" {
  key_name   = var.key_name
  public_key = file("C:/Users/GISHNURAJ/.ssh/id_rsa.pub") # Ensure you have a valid SSH key
}

resource "aws_instance" "gem_instance" {
  ami           = var.ami_id # Example AMI, replace with a valid one
  instance_type = var.instance_type
  key_name      = aws_key_pair.gem2_key.key_name
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.gems_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "gem-instance"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/GISHNURAJ/.ssh/id_rsa") # Ensure you have the corresponding private key
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py" # Path to your local script
    destination = "/home/ec2-user/app.py" # Path on the instance
    }
    
    
  provisioner "remote-exec" {
    inline = [
      "echo 'Running app.py script...'",
      "chmod +x /home/ec2-user/app.py", # Make the script executable
      "sudo yum update -y",
      "sudo yum install -y python3 pip",      # ensure pip is available
      "sudo pip3 install flask",
      "cd /home/ec2-user",
      "nohup python3 app.py > app.log 2>&1 &"  # <--- Run in background!
    ]
  }
}

resource "aws_s3_bucket" "gems_bucket" {
  bucket = "gems-bucket-tfstate-files"
}

resource "aws_dynamodb_table" "gems-terraform-lock" {
  name           = "gems-terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}