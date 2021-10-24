# tfsec:ignore:aws-vpc-add-description-to-security-group
resource "aws_security_group" "efs" {
  # checkov:skip=CKV_AWS_23:Description
  count = var.security_group_ids == null ? 1 : 0

  name_prefix = "${var.name}-"
  vpc_id      = var.vpc_id

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "efs_ingress" {
  # checkov:skip=CKV_AWS_23:Descriptions
  count = var.security_group_ids == null && var.vpc_cidr != null ? 1 : 0

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.efs[0].id
  cidr_blocks       = [var.vpc_cidr]
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
# tfsec:ignore:aws-vpc-add-description-to-security-group
resource "aws_security_group_rule" "efs_egress" {
  # checkov:skip=CKV_AWS_23:Descriptions
  count = var.security_group_ids == null ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.efs[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_efs_file_system" "this" {
  # checkov:skip=CKV2_AWS_18:Backup
  count = var.create_efs ? 1 : 0

  encrypted                       = true
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  kms_key_id                      = var.kms_key_id

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy

    content {
      transition_to_ia                    = lookup(lifecycle_policy.value, "transition_to_ia", null)
      transition_to_primary_storage_class = lookup(lifecycle_policy.value, "transition_to_primary_storage_class", null)
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_efs_mount_target" "this" {
  for_each = var.create_efs ? toset(var.subnet_ids) : toset([])

  file_system_id  = aws_efs_file_system.this[0].id
  subnet_id       = each.value
  security_groups = var.security_group_ids == null ? [aws_security_group.efs[0].id] : var.security_group_ids
}
