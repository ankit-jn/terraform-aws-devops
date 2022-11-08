############################################
## IAM Properties
############################################
variable "policies" {
  description = <<EOF
List of Policies to be provisioned where each entry will be a map for Policy configuration
Refer https://github.com/arjstack/terraform-aws-iam#policy for the structure
EOF
  default = []
}

############################################
## CodeCommit Properties
############################################
variable "repository_name" {
    description = "The name for the repository."
    type        = string
    default     = null

    validation {
        condition = try(length(var.repository_name), 0) < 100
        error_message = "Length of Repository name can not exceed 100 characters."
    }
}

variable "repository_description" {
    description = "The description for the repository."
    type        = string
    default     = null

    validation {
        condition = try(length(var.repository_description), 0) < 1000
        error_message = "Length of Repository name can not exceed 1000 characters."
    }
}

############################################
## CodeBuild Properties
############################################
variable "stages" {
    description = <<EOF
List of CodeBuils Projects where each entry is a map of project configuration

name            : (Required) Project's name.
description     : (Optional) Short description of the project.
build_timeout   : (Optional) Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed.
                  Default - `60`
project_visibility: (Optional) Specifies the visibility of the project's builds.
queued_timeout  : (Optional) Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out.
source_version  : (Optional) Version of the build input to be built for this project. If not specified, the latest version is used.

env_image           : (Optional) Docker image to use for this build project.
env_type            : (Optional) Type of build environment to use for related builds.
env_compute_type    : (Required) Information about the compute resources the build project will use.
env_certificate     : (Optional) ARN of the S3 bucket, path prefix and object key that contains the PEM-encoded certificate.
env_privileged_mode : (Optional) Whether to enable running the Docker daemon inside a Docker container. 
env_credential_type : (Optional) Type of credentials AWS CodeBuild uses to pull images in your build.
env_variables       : (optional) List of Environment Variables Map
        name    : (Required) Environment variable's name or key.
        type    : (Optional) Type of environment variable.
        value   : (Required) Environment variable's value.
env_registry_credential: (Optional) ARN or name of credentials created using AWS Secrets Manager.
tags            : (Optional) A map of tags to assign to project.
EOF
    default     = {}
}

variable "codebuild_policies" {
  description = <<EOF
List of Policies to be attached with Service role for CodeBuild where each entry will be map with following entries
    name - Policy Name
    arn - Policy ARN (if existing policy)
EOF
  default = [
    {
        name = "AdministratorAccess"
        arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
    },
    {
        name = "AWSCodeCommitReadOnly"
        arn  = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
    },
  ]
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

variable "account_id" {
    description = "AWS account ID"
    type = string
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

############################################
## Tags Properties
############################################
variable "default_tags" {
    description = "A map of tags to assign to all the resources."
    type        = map(string)
    default     = {}
}

variable "repository_tags" {
    description = "A map of tags to assign to the Repository."
    type        = map(string)
    default     = {}
}

variable "project_tags" {
    description = "A map of tags to assign to all the CodeBuild Projects."
    type        = map(string)
    default     = {}
}