variable "package_name" {
	type        = string
	description = "The name of the package being produced."
}

variable "package_description" {
	type        = string
	default     = ""
	description = "A short description describing the package."
}

variable "is_browser_package" {
	type        = bool
	default     = true
	description = "Indicates whether the package is compatible with a web browser environment."
}

variable "is_node_package" {
	type        = bool
	default     = true
	description = "Indicates whether the package is compatible with a NodeJS environment."
}

variable "is_cli_package" {
	type        = bool
	default     = false
	description = "Indicates whether the package includes a CLI executable to be installed into the PATH."
}

variable "supported_node_versions" {
	type        = list(number)
	default     = [18, 20]
	description = "A list of NodeJS versions that the package supports. Only applicable if `is_node_package` is `true`."
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
