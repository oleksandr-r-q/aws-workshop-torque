resource "aws_security_group" "promotions-manager" {
  name        = "promotions-manager-${var.SANDBOX_ID}"
  description = "Allows inbound traffic"
  # vpc_id      = module.vpc.default_vpc_id
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    description = "port"
    from_port   = var.PORT
    to_port     = var.PORT
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    description = "api_port"
    from_port   = var.API_PORT
    to_port     = var.API_PORT
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    description = "mongo"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  egress {
    description = "all outbound connections are allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_inbound_access"
  }
}
