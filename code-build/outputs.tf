output "projects" {
    description = "CodeBuild Stages Attributes"
    value = {for stage in aws_codebuild_project.this: 
                        stage.name => {
                            id = stage.id
                            arn = stage.arn
                            badge_url = stage.badge_url
                        }}
}