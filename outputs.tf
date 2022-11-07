output "encryption_key" {
    description = "KMS customer master key (CMK) to be used for encrypting the build project's build output artifacts."
    value = (var.enable_encryption && var.create_encryption_key) ? {
                                           "key_id" = module.encryption_key[0].key_id
                                           "arn"    = module.encryption_key[0].key_arn 
                                           "policy" = module.encryption_key[0].key_policy 
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