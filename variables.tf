variable "account_id" {
    description = "AWS account ID"
    type = string
}

variable "encrypt_artifacts" {
    description = "Flag to decide if the build project's build output artifacts should be encrypted"
    type = bool
    default = true
}

variable "kms_key" {
    description = <<EOF
Existing KMS: customer master key (CMK) to be used for encrypting the build project's build output artifacts.
`create_encryption_key` will take preference over this property
EOF
    type = string
    default = null
}

############################################
## Bucket related properties
############################################

variable "codebuild_bucket_name" {
    description = "Bucket name for Code Build"
    type        = string
}

variable "codebuild_bucket_configs" {
    description = <<EOF
Configuration for Codebuild bucket
create              : (Optional, default `false`) Flag to decide if bucket should be created
enable_versioning   : (Optional, default `true`) Flag to decide if bucket versioning is enabled.
enable_sse          : (Optional, default `true`) Flag to decide if server side encryption is enabled.
sse_kms             : (Optional, default `true`) Flag to decide if sse-algorithm is `aws-kms`.
use_kms_key         : (Optional, default `true`) Flag to decide if KMS-CMK is used for encryption.
EOF
    type = map(bool)
    default = {
        create = true
    }
}

variable "codepipeline_bucket_name" {
    description = "Bucket name for Code Pipeline"
    type        = string
}

variable "codepipeline_bucket_configs" {
    description = <<EOF
Configuration for Code Pipeline bucket if needs to create
create              : (Optional, default `false`) Flag to decide if bucket should be created
enable_versioning   : (Optional, default `true`) Flag to decide if bucket versioning is enabled.
enable_sse          : (Optional, default `true`) Flag to decide if server side encryption is enabled.
sse_kms             : (Optional, default `true`) Flag to decide if sse-algorithm is `aws-kms`
use_kms_key         : (Optional, default `false`) Flag to decide if KMS-CMK is used for encryption
EOF
    type = map(bool)
    default = {
        create = true
    }
}

############################################
## Artifact Encryption related properties
############################################
variable "create_kms_key" {
    description = <<EOF
Flag to decide if KMS-Customer Master Key 
should be created to encrypt codebuild output artifacts
EOF
    type = bool
    default = true
}

variable "kms_key_configs" {
    description = <<EOF
AWS KMS: customer master key (CMK) Configurations.

description: (Optional) The description of the key as viewed in AWS console
key_spec: (Required) Key Specification
key_usage: (Required) Specifies the intended use of the key.
aliases: (Optional) List of the aliases.
bypass_policy_lockout_safety_check: (Optional) Flag to decide if the key policy lockout safety check should be bypassed.
deletion_window_in_days: (Optional) The waiting period, specified in number of days.
enable_key_rotation: (Optional) Flag to decide if KMS key rotation is enabled
multi_region: (Optional) Flag to decide if KMS key is multi-region or regiona
key_administrators: (Optional) List of ARNs of IAM principals allowed to do Key Administation
key_grants_users: (Optional) List of ARNs of IAM principals allowed to grant AWS servcies to use the key
key_users: (Optional) List of ARNs of IAM principals, allowed to use the key
tags: (Optional) A map of tags to assign to the KMS key.

Refer `https://github.com/arjstack/terraform-aws-kms/blob/main/README.md` for the detailed info of the structure
EOF
    default = {
        key_spec    = "SYMMETRIC_DEFAULT"
        key_usage   = "ENCRYPT_DECRYPT"
    }
}