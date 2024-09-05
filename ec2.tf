resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id       = [aws_subnet.FW-MGMT-security[5].id]
  vpc_security_group_ids = [aws_security_group.appsg.id]
  key_name      = "omnex2" # Replace with your key pair

  tags = {
    Name = "bastion-server"
  }
}


# Create a Security Group
resource "aws_security_group" "appsg" {
  vpc_id     = aws_vpc.sec-vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
  # Allow inbound ICMP (ping) traffic from any source
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Allows ping from anywhere, change this if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastionapp-sg"
  }
}

