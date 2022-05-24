data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"
  name    = "vpc-${var.SANDBOX_ID}"
  cidr    = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  # tags = {
  #   Terraform = "true"
  #   Environment = var.env,
  #   sandbox_id = "${var.SANDBOX_ID}"
  # }
}