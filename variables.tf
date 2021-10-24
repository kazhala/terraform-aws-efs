variable "name" {
  description = "Purpose of the module."
  type        = string
}

variable "create_efs" {
  description = "Create EFS file syste."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC to provision the EFS."
  type        = string
}

variable "performance_mode" {
  description = "The file system performance mode. Can be either 'generalPurpose' or 'maxIO'."
  type        = string
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned."
  type        = number
  default     = null
}

variable "throughput_mode" {
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet to mount the EFS."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group to attach to the mount points."
  type        = list(string)
  default     = null
}

variable "lifecycle_policy" {
  description = "A list with max of 2 maps of lifecycle_policy."
  type        = any
  default     = []
}

variable "tags" {
  description = "Tags to apply to applicable resources."
  type        = map(string)
  default     = {}
}
