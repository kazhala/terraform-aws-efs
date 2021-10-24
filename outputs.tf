output "aws_security_group" {
  description = "Outputs of the security group created."

  value = {
    efs = var.security_group_ids == null ? aws_security_group.efs[0] : null
  }
}

output "aws_efs_file_system" {
  description = "Outputs of the EFS created."

  value = {
    this = var.create_efs ? aws_efs_file_system.this : null
  }
}
