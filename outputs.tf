output "kms_key" {
    description = "KMS customer master key (CMK) to be used for encryption."
    value = local.create_kms_key ? {
                                    "key_id" = module.encryption[0].key_id
                                    "arn"    = module.encryption[0].key_arn 
                                    "policy" = module.encryption[0].key_policy 
                                } : null
}

output "codebuild_bucket_arn" {
    description = "Code Build Bucket ARN"
    value = local.create_codebuild_bucket ? module.codebuild_bucket[0].arn : ""
}

output "codepipeline_bucket_arn" {
    description = "Code Pipeline Bucket ARN"
    value = local.create_codepipeline_bucket ? module.codepipeline_bucket[0].arn : ""
}