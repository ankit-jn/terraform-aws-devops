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
variable "build_stages" {
    description = <<EOF
List of CodeBuild Projects where each entry is a map of CodeBuild Project configuration

name            : (Required) Project's name.
description     : (Optional) Short description of the project.

artifacts_type                  : (Required) Build output artifact's type. 
artifacts_bucket_owner_access   : (Optional) Specifies the bucket owner's access for objects that another account uploads to their Amazon S3 bucket. Valid values are `NONE`, `READ_ONLY`, and `FULL`.
artifacts_location              : (Optional) Information about the build output artifact location. If type is set to `CODEPIPELINE` or `NO_ARTIFACTS`, this value is ignored. If type is set to `S3`, this is the name of the output bucket.
artifacts_name                  : (Optional) Name of the project. If type is set to S3, this is the name of the output artifact object.
artifacts_namespace_type        : (Optional) Namespace to use in storing build artifacts. If type is set to S3, then valid values are `BUILD_ID`, `NONE`.
artifacts_override_name         : (Optional) Whether a name specified in the build specification overrides the artifact name.
artifacts_packaging             : (Optional) Type of build output artifact to create. If type is set to S3, valid values are `NONE`, `ZIP`
artifacts_path                  : (Optional) If type is set to S3, this is the path to the output artifact.

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
env_registry_credential: (Optional) ARN or name of credentials created using AWS Secrets Manager for accessing a private Docker registry.

source_type             : (Required) Type of repository that contains the source code to be built.
source_location         : (Optional) Location of the source code from git or s3.
source_buildspec        : (Optional) Build specification to use for this build project's related builds.
source_insecure_ssl      : (Optional) Ignore SSL warnings when connecting to source control.
source_report_build_status: (Optional) Whether to report the status of a build's start and finish to your source provider.

vpc_id              : (Optional) ID of the VPC within which to run builds.
subnets             : (Optional) List of Subnet IDs within which to run builds.
security_group_ids  : (Optional) List of Security group IDs to assign to running builds.

cache_type      : (Optional) Type of storage that will be used for the AWS CodeBuild project cache.
cache_location  : (Optional) Location where the AWS CodeBuild project stores cached resources. Required when `cache_type` is set as `S3`.
cache_modes     : (Optional) Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Required when `cache_type` is set as `LOCAL`

enable_cw_logs  : (Optional) Flag to decide if Logging to Cloudwatch Group is enabled
log_cw_name     : (Optional) Group name of the logs in CloudWatch Logs.
log_cw_stream   : (Optional) Stream name of the logs in CloudWatch Logs.

enable_s3_logs : (Optional) Flag to decide if Logging to S3 is enabled

build_timeout   : (Optional) Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed.
                  Default - `60`
project_visibility: (Optional) Specifies the visibility of the project's builds.
queued_timeout  : (Optional) Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out.
source_version  : (Optional) Version of the build input to be built for this project. If not specified, the latest version is used.

tags            : (Optional) A map of tags to assign to project.
EOF
    default     = {}
}

variable "build_policies" {
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

variable "encrypt_build_artifacts" {
    description = "Flag to decide if the build project's build output artifacts should be encrypted"
    type = bool
    default = true
}

############################################
## CodePipeline Properties
############################################
variable "name" {
    description = "(Required) The name of the pipeline."
    type        = string
}

variable "pipeline_stages" {
    description = <<EOF
List of Pipeline stages where each entry is a map of CodePipeline Stage configuration

name: (Required) The name of the stage.
actions: (Required) List of actions to include in the stage. Each action will be a map as follows:
    name      : (Required) The action declaration's name.
    category  : (Required) Kind of action can be taken in the stage, and constrains the provider type for the action. 
    provider  : (Required) The provider of the service being called by the action.
    version   : (Required) A string that identifies the action type.
    owner     : (Required) The creator of the action being called. 
    run_order : (Optional) The order in which actions are run.
    region    : (Optional) The region in which to run the action.
    namespace : (Optional) The namespace all output variables will be accessed from.
    role_arn  : (Optional) The ARN of the IAM service role that will perform the declared action.
    input_artifacts : (Optional) A list of artifact names to be worked on.
    output_artifacts: (Optional) A list of artifact names to output. 
    embed_configuration: Flag to decide if `configuration` should be embdded
    configuration: (Optional) A map of the action declaration's configuration. 

                   Each Provider needs a different configuration. Refer the following article to set the proper values
                    https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements
    
EOF
    validation {
        condition = length(var.pipeline_stages) > 1
        error_message = "Please define atleast 2 stages."
    }
}

variable "encrypt_pipeline_artifacts" {
    description = "Flag to decide if the CodePipeline artifacts should be encrypted"
    type = bool
    default = true
}

variable "artifact_stores" {
    description = <<EOF
List of Configuration for additional Artifact Store where each entry is a map with following key-pair:
(Default is already configured in S3 bucket configured with `codepipeline_bucket_name`)

location: The location where AWS CodePipeline stores artifacts for a pipeline.
region: The region where the artifact store is located.
encryption_key: The KMS key ARN or ID
EOF
    type = list(map(string))
    default = []
}

variable "pipeline_policies" {
  description = <<EOF
List of Policies to be attached with Service role for CodePipeline where each entry will be map with following entries
    name - Policy Name
    arn - Policy ARN (if existing policy)
EOF
  default = [
    {
        name = "AdministratorAccess"
        arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
    },
    {
        name = "AWSCodeCommitFullAccess"
        arn  = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
    },
  ]
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
variable "kms_key" {
    description = <<EOF
Existing KMS: customer master key (CMK) to be used for encrypting CodeBuild/CodePipeline artifacts.
`create_encryption_key` will take preference over this property
EOF
    type = string
    default = null
}

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

variable "codebuild_tags" {
    description = "A map of tags to assign to all the CodeBuild Projects."
    type        = map(string)
    default     = {}
}

variable "codepipeline_tags" {
    description = "A map of tags to assign to all the CodeBuild Projects."
    type        = map(string)
    default     = {}
}