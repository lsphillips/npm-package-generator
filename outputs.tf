output "package_repository_url" {
	value       = github_repository.repository.http_clone_url
	description = "The URL of the repository that can be used to clone the package repository."
}
