output "public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.web.id
}

output "rds_endpoint" {
  description = "The RDS instance endpoint"
  value       = aws_db_instance.studentdb.endpoint
}

output "rds_port" {
  description = "The RDS instance port"
  value       = aws_db_instance.studentdb.port
}