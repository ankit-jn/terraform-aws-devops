output "pipeline" {
    description = "CodePipeline Attributes"
    value = {
                id  = aws_codepipeline.this.id
                arn = aws_codepipeline.this.arn
            }
}