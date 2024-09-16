resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = "t3.large"
  subnet_id       = aws_subnet.FW-MGMT-security[5].id
  vpc_security_group_ids = [aws_security_group.appsg.id]
  key_name      = "omnex2" # Replace with your key pair
  #map_public_ip_on_launch = true
  associate_public_ip_address = true
  # User data script to set the Windows Admin password
  user_data = <<-EOF
    <powershell>
    # Set Windows Administrator password
    $adminPassword = ConvertTo-SecureString "YourStrongPassword123!" -AsPlainText -Force
    $adminAccount = [ADSI]"WinNT://./Administrator,User"
    $adminAccount.SetPassword($adminPassword)
    $adminAccount.SetInfo()
    </powershell>
  EOF
  tags = {
    Name = "bastion-server"
  }
}


# Create a Security Group
resource "aws_security_group" "appsg" {
  vpc_id     = aws_vpc.sec-vpc.id


# Allow RDP access from your IP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
  }

  # Allow SQL Server access from your IP (or other trusted sources)
  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
  }

  ingress {
    from_port   = 1434
    to_port     = 1434
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
  }

  
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

