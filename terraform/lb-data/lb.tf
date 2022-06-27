data "aws_lb" "lb" {
  name = "promotions-manager"
  tags = {
    relase = "promotions-manager",
    env = "test"
    "elbv2.k8s.aws/cluster" = var.cluster_name
  }
}