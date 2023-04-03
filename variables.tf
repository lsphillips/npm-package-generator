variable "package_name" {
	type        = string
	description = "The name of the package being produced."
}

variable "package_description" {
	type        = string
	default     = ""
	description = "A short description describing the package."
}

variable "is_browser_compatible" {
	type        = bool
	default     = true
	description = "Indicates whether the package is compatible with a web browser environment."
}

variable "is_node_compatible" {
	type        = bool
	default     = true
	description = "Indicates whether the package is compatible with a NodeJS environment."
}

variable "supported_node_versions" {
	type        = list(number)
	default     = [16, 18]
	description = "A list of NodeJS versions that the package supports. Only applicable if `is_node_compatible` is `true`."
}

variable "author_name" {
	type        = string
	description = "The name of the author of the package."
}

variable "author_email" {
	type        = string
	description = "The email address for the author of the package. This will be public!"
}

variable "is_public" {
	type        = bool
	default     = false
	description = "Indicates if the package is to be public."
}
