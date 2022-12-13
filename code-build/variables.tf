variable "repository_name" {
    description = "The name for the repository."
    type        = string
}

variable "environment" {
    description = "DevOps Environment"
    type        = string
}

variable "service_role" {
    description = "IAM Role for CodeBuild"
    type        = string
}

variable "bucket_name" {
    description = "Bucket name for Code Build Artifacts"
    type        = string
}

variable "build_stages" {
    description = "List of CodeBuild Projects where each entry is a map of CodeBuild Project configuration"
}

variable "encrypt_artifacts" {
    description = "Flag to decide if the build project's build output artifacts should be encrypted"
    type = bool
}

variable "kms_key" {
    description = "Customer master key (CMK) to be used for encrypting CodeBuild artifacts"
    type = string
}

variable "tags" {
    description = "A map of tags to assign to all the CodeBuild Projects."
    type        = map(string)
}