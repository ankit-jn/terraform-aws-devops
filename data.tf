data aws_s3_bucket "codebuild" {
    count = local.create_codebuild_bucket ? 0 : 1
    
    bucket = var.codebuild_bucket_name
}

data aws_s3_bucket "codepipeline" {
    count = local.create_codepipeline_bucket ? 0 : 1
    
    bucket = var.codepipeline_bucket_name
}

