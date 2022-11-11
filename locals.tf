locals {
    
    create_build_projects = length(var.build_stages) > 0
    create_pipeline = length(var.pipeline_stages) > 1

    ## IAM Service Roles
    codebuild_role_name = coalesce(var.codebuild_service_role_name, format("codebuild-%s", var.repository_name))
    codebuild_role_def = var.create_codebuild_service_role ? [                
                        {
                            name = local.codebuild_role_name
                            description = "IAM Role with trusted Entity - AWS CodeBuild Service"
                            service_names = [
                                "codebuild.amazonaws.com"
                            ]
                            policy_list =  var.codebuild_policies            
                        }
                    ] : []

    codepipeline_role_name = coalesce(var.codepipeline_service_role_name, format("codepipeline-%s", var.repository_name))
    codepipeline_role_def =  var.create_codepipeline_service_role ? [                
                            {
                                name = local.codepipeline_role_name
                                description = "IAM Role with trusted Entity - AWS CodeBuild Service"
                                service_names = [
                                    "codepipeline.amazonaws.com"
                                ]
                                policy_list =  var.codepipeline_policies            
                            }
                    ] : []
    create_devops_roles = var.create_codebuild_service_role || var.create_codepipeline_service_role 
    devops_roles_def = concat(local.codebuild_role_def, local.codepipeline_role_def)
    
    ## S3 Buckets
    use_codebuild_specific_bucket = (var.codebuild_bucket != null && var.codebuild_bucket != "")
    use_codepipeline_specific_bucket = (var.codepipeline_bucket != null && var.codepipeline_bucket != "")
    create_devops_bucket = var.create_bucket && var.bucket_name != null && var.bucket_name != ""

    devops_bucket_name = local.create_devops_bucket ? module.devops_bucket[0].id : (var.bucket_name != null 
                                                                                    && var.bucket_name != "") ? data.aws_s3_bucket.devops[0].id : null
    devops_bucket_region = local.create_devops_bucket ? module.devops_bucket[0].region : (var.bucket_name != null 
                                                                                    && var.bucket_name != "") ? data.aws_s3_bucket.devops[0].region : null

    codebuild_bucket_name =  local.use_codebuild_specific_bucket ? data.aws_s3_bucket.codebuild[0].id : local.devops_bucket_name
    codebuild_bucket_region =  local.use_codebuild_specific_bucket ? data.aws_s3_bucket.codebuild[0].region : local.devops_bucket_region

    codepipeline_bucket_name =  local.use_codepipeline_specific_bucket ? data.aws_s3_bucket.codepipeline[0].id : local.devops_bucket_name
    codepipeline_bucket_region =  local.use_codepipeline_specific_bucket ? data.aws_s3_bucket.codepipeline[0].region : local.devops_bucket_region

    ## KMS Key
    create_kms_key = var.create_kms_key && (var.encrypt_build_artifacts 
                                                || var.encrypt_pipeline_artifacts
                                                || (local.create_devops_bucket 
                                                            && try(var.bucket_configs.enable_sse, true) 
                                                            && try(var.bucket_configs.sse_kms, true) 
                                                            && try(var.bucket_configs.use_kms_key, false)))
    kms_key = local.create_kms_key ? module.encryption[0].key_id : try(var.kms_key, null)
}