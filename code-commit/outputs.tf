output "repository" {
    description = "CodeCommit Repository Attributes"
    value = {
                id  = aws_codecommit_repository.this.repository_id 
                arn = aws_codecommit_repository.this.arn
                clone_url_http = aws_codecommit_repository.this.clone_url_http
                clone_url_ssh = aws_codecommit_repository.this.clone_url_ssh
            }
}