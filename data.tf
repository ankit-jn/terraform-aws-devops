data aws_s3_bucket "codebuild" {
    count = local.create_build_projects ? (local.create_codebuild_bucket ? 0 : 1) : 0
    
    bucket = var.codebuild_bucket_name
}

data aws_s3_bucket "codepipeline" {
    count = local.create_pipeline ? (local.create_codepipeline_bucket ? 0 : 1) : 0
    
    bucket = var.codepipeline_bucket_name
}

data aws_ssm_parameter "webhook_secret" {
    count = var.enable_webhook ? (var.generate_webhook_secret ? 0 : 1) : 0 
    
    name = var.webhook_secret_param    
}