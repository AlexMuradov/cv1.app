output "vpc_main" {
  value = aws_vpc.cv1app.id
}

output "subnet_main" {
  value = aws_subnet.cv1app[*]
}

output "sg_main" {
  value = aws_security_group.cv1app.id
}