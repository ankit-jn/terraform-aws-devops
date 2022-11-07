variable "account_id" {
    description = "AWS account ID"
    type = string
}

variable "enable_encryption" {
    description = "Flag to decide if the build project's build output artifacts should be encrypted"
    type = bool
    default = true
}

variable "encryption_key" {
    description = <<EOF
Existing KMS: customer master key (CMK) to be used for encrypting the build project's build output artifacts.
`create_encryption_key` will take preference over this property
EOF
    type = string
    default = null
}

variable "create_encryption_key" {
    description = <<EOF
Flag to decide if KMS-Customer Master Key 
should be created to encrypt codebuild output artifacts
EOF
    type = bool
    default = true
}

variable "encryption_key_configs" {
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
key_symmetric_encryption_users: (Optional) List of ARNs of IAM principals, allowed to use the key for Encryption/Decryption
key_symmetric_hmac_users: (Optional) List of ARNs of IAM principals, allowed to use the key for Generate and Verify HMAC
key_asymmetric_public_encryption_users: (Optional) List of ARNs of IAM principals, allowed to use the key for Encryption/Decryption
key_asymmetric_sign_verify_users: (Optional) List of ARNs of IAM principals, allowed to use the key for Sign/Verify
tags: (Optional) A map of tags to assign to the KMS key.

Refer `https://github.com/arjstack/terraform-aws-kms/blob/main/README.md` for the detailed info of the structure
EOF
    type = map(any)
    default = {
        key_spec    = "SYMMETRIC_DEFAULT"
        key_usage   = "ENCRYPT_DECRYPT"
    }
}