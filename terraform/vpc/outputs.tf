output "public_subnet" {
  value = module.vpc.public_subnets[0]
}

output "public_subnet_1" {
  value = module.vpc.public_subnets[1]
}

output "private_subnets" {
  value = module.vpc.private_subnets[0]
}
output "aws_security_group_id" {
  value = aws_security_group.promotions-manager.id
}
output "instance_profile" {
  value = aws_iam_instance_profile.promotions-manager.name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
