output "public_dns" {
  value = aws_instance.promotions-manager.public_dns
}

output "public_ip" {
  value = aws_instance.promotions-manager.public_ip
}

output "private_ip" {
  value = aws_instance.promotions-manager.private_ip
}

output "private_dns" {
  value = aws_instance.promotions-manager.private_dns
}