# outputs.tf - Output Values

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "ec2_public_ips" {
  description = "EC2 public IPs"
  value       = var.use_ec2_instead_of_eks ? aws_eip.ec2[*].public_ip : null
}

output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = var.use_ec2_instead_of_eks ? aws_instance.app[*].id : null
}

output "ssh_command" {
  description = "SSH command for EC2"
  value       = var.use_ec2_instead_of_eks && length(aws_eip.ec2) > 0 ? "ssh -i ~/.ssh/${var.ssh_key_name}.pem ec2-user@${aws_eip.ec2[0].public_ip}" : null
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.postgresql.endpoint
}

output "rds_address" {
  description = "RDS address"
  value       = aws_db_instance.postgresql.address
}

output "database_url" {
  description = "Database connection URL"
  value = "postgresql://${aws_db_instance.postgresql.username}:${var.db_password}@${aws_db_instance.postgresql.endpoint}/${aws_db_instance.postgresql.db_name}"
  sensitive   = true
}

output "redis_endpoint" {
  description = "Redis endpoint"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  description = "Redis port"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].port
}

output "redis_url" {
  description = "Redis connection URL"
  value       = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}/0"
}