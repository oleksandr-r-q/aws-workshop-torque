variable AWS_REGION {
  type    = string
  default = "us-west-2"
}

variable "instance_type" {
  type    = string
  default = "t3a.micro"
}

variable "volume_size" {
  default = "20"
}

variable "volume_type" {
  type    = string
  default = "standard"
}


variable "ssh_port" {
  default = "22"
}

variable SANDBOX_ID {
  default = "test"
}

variable "env" {
  default = "test"
}


variable "cidr_blocks" {
  type = list(any)
  default = ["0.0.0.0/0"]
}

variable "API_PORT" {
  type = number
  default = 3001
}

variable "PORT" {
  type = number
  default = 3000
}

variable "instance_profile" {
  default = "promotions-manager-test12"
}

variable "public_subnet" {
  default = "subnet-0eb28836bc07d12f5"
}

variable "aws_security_group_id" {
  default = "sg-06c5055e14615efd2"
}

variable "aws_s3_bucket" {
  default = "artifact-repo-promotionapp-oleksandr"
}

variable "artifacts_path_mongodb" {
  default = "artifacts/test-data"
}

variable "artifacts_path_promotions-manager-api" {
  default = "artifacts/latest"
}

variable "artifacts_path_promotions-manager-ui" {
  default = "artifacts/latest"
}
variable "RELEASE_NUMBER" {
  default = "none"
}

variable "API_BUILD_NUMBER" {
  default = "none"
}
