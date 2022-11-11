output "codecommit_repository" {
    description = "CodeCommit Repository Attributes"
    value = var.create_repository ? module.code_commit[0].repository : {}
}

output "codebuild_projects" {
    description = "CodeBuild Stages Attributes"
    value = local.create_build_projects ? module.code_build[0].projects : {}
}

output "codepipeline" {
    description = "CodePipeline Attributes"
    value = local.create_pipeline ? module.code_pipeline[0].pipeline: {}
}

output "codebuild_bucket_arn" {
    description = "Code Build Bucket ARN"
    value = local.create_codebuild_bucket ? module.codebuild_bucket[0].arn : ""
}

output "codepipeline_bucket_arn" {
    description = "Code Pipeline Bucket ARN"
    value = local.create_codepipeline_bucket ? module.codepipeline_bucket[0].arn : ""
}

output "kms_key" {
    description = "KMS customer master key (CMK) to be used for encryption."
    value = local.create_kms_key ? {
                                    "key_id" = module.encryption[0].key_id
                                    "arn"    = module.encryption[0].key_arn 
                                    "policy" = module.encryption[0].key_policy 
                                } : null
}

output "ssm_parameter_webhook_secret" {
    description = "SSM parameter were webhook secret is stored."
    value = (var.enable_webhook 
                    && var.generate_webhook_secret) ? module.webhook[0].ssm_parameter_webhook_secret : ""
}