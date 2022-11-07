locals {
    create_kms_key = var.encrypt_codebuild_artifacts && var.create_kms_key
    
    create_codebuild_bucket     = try(var.codebuild_bucket_configs.create, false)
    create_codepipeline_bucket  = try(var.codepipeline_bucket_configs.create, false)
}