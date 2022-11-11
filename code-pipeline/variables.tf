variable "repository_name" {
    description = "The name for the repository."
    type        = string
}

variable "pipeline_name" {
    description = "(Required) The name of the pipeline."
    type        = string
}

variable "service_role" {
    description = "IAM Role for CodePipeline"
    type        = string
}

variable "bucket_name" {
    description = "Bucket name for Code Pipeline Artifacts"
    type        = string
}

variable "bucket_region" {
    description = "Region where Bucket for Code Pipeline is placed in."
    type        = string
}

variable "artifact_stores" {
    description = "List of Configuration for additional Artifact Store"
    type = list(map(string))
}

variable "pipeline_stages" {
    description = "List of Pipeline stages"
}

variable "encrypt_artifacts" {
    description = "Flag to decide if the CodePipeline artifacts should be encrypted"
    type = bool
}

variable "kms_key" {
    description = "Customer master key (CMK) to be used for encrypting CodePipeline artifacts"
    type = string
}

variable "tags" {
    description = "A map of tags to assign to CodePipeline."
    type        = map(string)
}
