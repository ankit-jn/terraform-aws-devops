variable "repository_name" {
    description = "The name for the repository."
    type        = string
}

variable "repository_description" {
    description = "The description for the repository."
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the Repository."
    type        = map(string)
}