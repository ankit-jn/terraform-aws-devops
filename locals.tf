locals {
    create_codebuild_bucket     = try(var.codebuild_bucket_configs.create, false)
    create_codepipeline_bucket  = try(var.codepipeline_bucket_configs.create, false)

    create_kms_key = var.create_kms_key && (var.encrypt_artifacts 
                                                || (local.create_codebuild_bucket 
                                                            && try(var.codebuild_bucket_configs.enable_sse, true) 
                                                            && try(var.codebuild_bucket_configs.sse_kms, true) 
                                                            && try(var.codebuild_bucket_configs.use_kms_key, false))
                                                || (local.create_codepipeline_bucket
                                                            && try(var.codepipeline_bucket_configs.enable_sse, true) 
                                                            && try(var.codepipeline_bucket_configs.sse_kms, true) 
                                                            && try(var.codepipeline_bucket_configs.use_kms_key, false)))
    kms_key = local.create_kms_key ? module.encryption[0].key_id : try(var.kms_key, null)

    devops_roles = [                
                        {
                            name = format("%s-codebuild", var.repository_name)
                            description = "IAM Role with trusted Entity - AWS CodeBuild Service"
                            service_names = [
                                "codebuild.amazonaws.com"
                            ]
                            policy_list =  var.codebuild_policies            
                        }
                    ]
}