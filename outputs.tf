output "bucket_arn" {
    description = "DevOps Bucket ARN"
    value = local.create_devops_bucket ? module.devops_bucket[0].arn : ""
}

output "codebuild_service_role" {
    description = "ARN of IAM Role for CodeBuild Service"
    value = var.create_codebuild_service_role ? module.iam_devops[0].service_linked_roles[local.codebuild_role_name].arn : null
}

output "codepipeline_service_role" {
    description = "ARN of IAM Role for CodePipeline Service"
    value = var.create_codepipeline_service_role ? module.iam_devops[0].service_linked_roles[local.codepipeline_role_name].arn : null
}

output "codecommit_repository" {
    description = "CodeCommit Repository Attributes"
    value = var.create_repository ? module.code_commit[0].repository : {}
}

output "codebuild_projects" {
    description = "CodeBuild Project Attributes"
    value = local.create_build_projects ? module.code_build[0].projects : {}
}

output "codepipeline" {
    description = "CodePipeline Attributes"
    value = local.create_pipeline ? module.code_pipeline[0].pipeline: {}
}

output "ssm_parameter_webhook_secret" {
    description = "SSM parameter where webhook secret is stored."
    value = (var.enable_webhook 
                    && var.generate_webhook_secret) ? module.webhook[0].ssm_parameter_webhook_secret : ""
}

output "kms_key" {
    description = "KMS customer master key (CMK) to be used for encryption."
    value = local.create_kms_key ? {
                                    "key_id" = module.encryption[0].key_id
                                    "arn"    = module.encryption[0].key_arn 
                                    "policy" = module.encryption[0].key_policy 
                                } : null
}