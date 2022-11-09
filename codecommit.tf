resource aws_codecommit_repository "this" {
    count = var.create_repository ? 1 : 0
    
    repository_name = var.repository_name
    description     = coalesce(var.repository_description, var.repository_name)

    tags = merge({"Name" = var.repository_name}, var.default_tags, var.repository_tags)
}