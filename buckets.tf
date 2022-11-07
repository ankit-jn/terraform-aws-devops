module "codebuild_bucket" {
    source = "git::https://github.com/arjstack/terraform-aws-s3?ref=v1.0.0"
    
    count = local.create_codebuild_bucket ? 1 : 0

    name = var.codebuild_bucket_name
    
    enable_versioning   = try(var.codebuild_bucket_configs.enable_versioning, true)
    versioning          = try(var.codebuild_bucket_configs.enable_versioning, true) ? { status = "Enabled" } : {}

    enable_sse              = try(var.codebuild_bucket_configs.enable_sse, true)
    server_side_encryption  = try(var.codebuild_bucket_configs.enable_sse, true) ? { sse_algorithm = "aws:kms"} : {}

    acl = "private"

    default_tags = try(var.codebuild_bucket_configs.tags, {})
}

module "codepipeline_bucket" {
    source = "git::https://github.com/arjstack/terraform-aws-s3?ref=v1.0.0"
    
    count = local.create_codepipeline_bucket ? 1 : 0

    name = var.codebuild_bucket_name
    
    enable_versioning   = try(var.codepipeline_bucket_configs.enable_versioning, true)
    versioning          = try(var.codepipeline_bucket_configs.enable_versioning, true) ? { status = "Enabled" } : {}

    enable_sse              = try(var.codepipeline_bucket_configs.enable_sse, true)
    server_side_encryption  = try(var.codepipeline_bucket_configs.enable_sse, true) ? { sse_algorithm = "aws:kms"} : {}

    acl = "private"

    default_tags = try(var.codepipeline_bucket_configs.tags, {})
}

