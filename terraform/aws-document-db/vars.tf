variable "AWS_REGION" {
  type    = string
  default = "us-west-2"
}
variable SANDBOX_ID {
  type    = string
  default = "test"
}
variable "USERNAME" {
    default = "adminuser"
}
variable "PASSWORD" {
    default = "Welcome1234567+"
}
variable "INSERT_DATA" {
    default = false
}
variable "DB_NAME" {
    default = "test"
}
variable "COLLECTION_NAME" {
    default = "test"
}

variable "vpc_id" {
  default = "test"
}

variable "public_subnet" {
  default = "subnet-0e6cce5819d3c7ed7"
}

variable "aws_security_group_id" {
  default = "sg-04510ffc4e38e54bc"
}

variable "public_subnet_1" {
  default = "subnet-0e6cce5819d3c7ed7"
}

variable "env" {
  default = "test"
}