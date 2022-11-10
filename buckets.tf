module "codebuild_bucket" {
    source = "git::https://github.com/arjstack/terraform-aws-s3?ref=v1.0.0"
    
    count = local.create_codebuild_bucket ? 1 : 0

    name = var.codebuild_bucket_name
    
    enable_versioning   = lookup(var.codebuild_bucket_configs, "enable_versioning", true)
    versioning          = lookup(var.codebuild_bucket_configs, "enable_versioning", true) ? { status = "Enabled" } : {}

    enable_sse              = lookup(var.codebuild_bucket_configs, "enable_sse", true)
    server_side_encryption  = lookup(var.codebuild_bucket_configs, "enable_sse", true) ? { 
                                        sse_algorithm = lookup(var.codebuild_bucket_configs, "sse_kms", true) ? "aws:kms" : "AES256"
                                        kms_key = lookup(var.codebuild_bucket_configs, "use_kms_key", false) ? local.kms_key : null
                                    } : {}    
    acl = "private"

    default_tags = try(var.codebuild_bucket_configs.tags, {})
}

module "codepipeline_bucket" {
    source = "git::https://github.com/arjstack/terraform-aws-s3?ref=v1.0.0"
    
    count = local.create_codepipeline_bucket ? 1 : 0

    name = var.codebuild_bucket_name
    
    enable_versioning   = lookup(var.codepipeline_bucket_configs, "enable_versioning", true)
    versioning          = lookup(var.codepipeline_bucket_configs, "enable_versioning", true) ? { status = "Enabled" } : {}

    enable_sse              = lookup(var.codepipeline_bucket_configs, "enable_sse", true)
    server_side_encryption  = lookup(var.codepipeline_bucket_configs, "enable_sse", true) ? { 
                                        sse_algorithm = lookup(var.codepipeline_bucket_configs, "sse_kms", true) ? "aws:kms" : "AES256"
                                        kms_key = lookup(var.codepipeline_bucket_configs, "use_kms_key", false) ? local.kms_key : null
                                    } : {}    

    acl = "private"

    default_tags = try(var.codepipeline_bucket_configs.tags, {})
}

