provider "aws" {
  region     = "${var.AWS_REGION}"
  default_tags {
    tags = {
        Terraform = "true"
        Environment = var.env,
        sandbox_id = "${var.SANDBOX_ID}"
    }
  }
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}
