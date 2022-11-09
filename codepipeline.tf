resource aws_codepipeline "this" {
    name = var.name

    role_arn = module.iam_devops.service_linked_roles[local.codepipeline_role_name].arn

    artifact_store {
        location = var.codebuild_bucket_name
        type     = "S3"
        region   = local.create_codepipeline_bucket ? module.codepipeline_bucket[0].region : data.aws_s3_bucket.codepipeline[0].region
        dynamic "encryption_key" {
            for_each = var.encrypt_pipeline_artifacts ? [1] : []

            content {
                id = local.kms_key
                type = "KMS"
            }
        }
    }

    ## Additional Artifact stores
    dynamic "artifact_store" {
        for_each = var.artifact_stores
        content {
            location = artifact_store.value.location
            type     = "S3"
            region   = lookup(artifact_store.value, "region", null)

            dynamic "encryption_key" {
                for_each = try(artifact_store.value.encryption_key, "") != "" ? [1] : []

                content {
                    id = artifact_store.value.encryption_key
                    type = "KMS"
                }
            }
        }
    }

    dynamic "stage" {
        for_each = var.pipeline_stages

        content {
            name = stage.value.name

            dynamic "action" {
                for_each = stage.value.actions

                content {
                    name        = action.value.name
                    category    = action.value.category
                    provider    = action.value.provider
                    version     = action.value.version
                    owner       = try(action.value.owner, "AWS")
                    
                    run_order   = try(action.value.run_order, null)
                    region      = try(action.value.region, null)
                    namespace   = try(action.value.namespace, null)
                    role_arn    = try(action.value.role_arn, null)

                    input_artifacts     = try(action.value.input_artifacts, null)
                    output_artifacts    = try(action.value.output_artifacts, null)

                    ## Configuration for `CodeCommit` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "CodeCommit") ? [1] : []

                        content {
                            RepositoryName = var.repository_name
                            BranchName = action.value.configuration.branch
                            PollForSourceChanges = try(action.value.configuration.PollForSourceChanges, false)
                        }
                    }

                    ## Configuration for `CodeBuild` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "CodeBuild") ? [1] : []

                        content {
                            ProjectName = aws_codebuild_project.this[action.value.configuration.build_stage_name].name
                            PrimarySource = action.value.configuration.PrimarySource
                            BatchEnabled = try(action.value.configuration.BatchEnabled, false)
                            CombineArtifacts = try(action.value.configuration.CombineArtifacts, false)
                            EnvironmentVariables = jsonencode(try(action.value.configuration.EnvironmentVariables, []))
                        }
                    }

                    ## Configuration for `CodeDeploy` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "CodeDeploy") ? [1] : []

                        content {
                            ApplicationName = action.value.configuration.ApplicationName
                            DeploymentGroupName = action.value.configuration.DeploymentGroupName
                        }
                    }

                    ## Configuration for `S3` Provider and `Source` Action
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "S3"
                                        && action.value.category == "Source") ? [1] : []

                        content {
                            S3Bucket = action.value.configuration.S3Bucket
                            S3ObjectKey = action.value.configuration.S3ObjectKey
                            PollForSourceChanges = try(action.value.configuration.PollForSourceChanges, false)
                        }
                    }

                    ## Configuration for `S3` Provider and `Deploy` Action
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "S3"
                                        && action.value.category == "Deploy") ? [1] : []

                        content {
                            BucketName = action.value.configuration.BucketName
                            Extract = action.value.configuration.Extract
                            ObjectKey = try(action.value.configuration.ObjectKey, null)
                            KMSEncryptionKeyARN = try(action.value.configuration.KMSEncryptionKeyARN, null)
                            CannedACL = try(action.value.configuration.CannedACL, null)
                            CacheControl = try(action.value.configuration.CacheControl, null)
                        }
                    }

                    ## Configuration for `ECR` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "ECR") ? [1] : []

                        content {
                            RepositoryName = action.value.configuration.RepositoryName
                            ImageTag = try(action.value.configuration.ImageTag, null)
                        }
                    }

                    ## Configuration for `GitHub` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "GitHub") ? [1] : []

                        content {
                            Owner = action.value.configuration.Owner
                            Repo = action.value.configuration.Repo
                            Branch = action.value.configuration.Branch
                            OAuthToken = action.value.configuration.OAuthToken
                            PollForSourceChanges = try(action.value.configuration.PollForSourceChanges, false)
                        }
                    }

                    ## Configuration for `Lambda` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "Lambda") ? [1] : []

                        content {
                            FunctionName = action.value.configuration.FunctionName
                            UserParameters = try(action.value.configuration.UserParameters, null)
                        }
                    }

                    ## Configuration for `ECS` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "ECS") ? [1] : []

                        content {
                            ClusterName = action.value.configuration.ClusterName
                            ServiceName = action.value.configuration.ServiceName
                            FileName = try(action.value.configuration.FileName, null)
                            DeploymentTimeout = try(action.value.configuration.DeploymentTimeout, null)
                        }
                    }

                    ## Configuration for `CodeDeployToECS` Provider
                    dynamic "configuration" {
                        for_each = (try(action.value.embed_configuration, false) 
                                        && action.value.provider == "ECS") ? [1] : []

                        content {
                            ApplicationName = action.value.configuration.ApplicationName
                            DeploymentGroupName = action.value.configuration.DeploymentGroupName
                            TaskDefinitionTemplateArtifact = try(action.value.configuration.TaskDefinitionTemplateArtifact, null)
                            AppSpecTemplateArtifact = action.value.configuration.AppSpecTemplateArtifact
                            AppSpecTemplatePath = try(action.value.configuration.AppSpecTemplatePath, null)
                            TaskDefinitionTemplatePath = try(action.value.configuration.TaskDefinitionTemplatePath, null)
                            Image1ArtifactName = try(action.value.configuration.Image1ArtifactName, null)
                            Image1ContainerName = try(action.value.configuration.Image1ContainerName, null)
                        }
                    }
                }
                
            }
        }
    }

    tags = merge({"Name" = var.name}, var.default_tags, var.codepipeline_tags)

    depends_on = [
        module.codepipeline_bucket
    ]
}