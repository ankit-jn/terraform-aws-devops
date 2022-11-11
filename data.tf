## S3 Bucket Data Sources
data aws_s3_bucket "devops" {
    count = local.create_devops_bucket ? 0 : (
                        (var.bucket_name != null 
                                && var.bucket_name != "") ? 1 : 0)
    
    bucket = var.bucket_name
}

data aws_s3_bucket "codebuild" {
    count = (var.codebuild_bucket != null 
                && var.codebuild_bucket != "") ? 1 : 0
    
    bucket = var.codebuild_bucket
}

data aws_s3_bucket "codepipeline" {
    count = (var.codepipeline_bucket != null 
                && var.codepipeline_bucket != "") ? 1 : 0
    
    bucket = var.codepipeline_bucket
}

## IAM Roles Data Sources
data aws_iam_role "codebuild" {
    count = var.create_codebuild_service_role ? 0 : (
                        (var.codebuild_service_role_name != null 
                                && var.codebuild_service_role_name != "") ? 1 : 0)
    
    name = var.codebuild_service_role_name
}

data aws_iam_role "codepipeline" {
    count = var.create_codepipeline_service_role ? 0 : (
                        (var.codepipeline_service_role_name != null 
                                && var.codepipeline_service_role_name != "") ? 1 : 0)
    
    name = var.codepipeline_service_role_name
}