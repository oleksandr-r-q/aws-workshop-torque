variable "AWS_REGION" {
  type    = string
  default = "us-west-2"
}

variable "SANDBOX_ID" {
  default = "test12"
}

variable "env" {
  default = "test"
}

variable "cidr_blocks" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "API_PORT" {
  type    = number
  default = 3001
}

variable "PORT" {
  type    = number
  default = 3000
}


