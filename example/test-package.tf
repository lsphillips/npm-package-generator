module "test_package_repository" {
	source                  = "git@github.com:lsphillips/npm-package-generator.git"
	package_name            = "test-package"
	package_description     = "This is a test package that can only be used in a NodeJS environment."
	is_browser_compatible   = false
	is_node_compatible      = true
	supported_node_versions = [16, 18]
	author_name             = "Luke Phillips"
	author_email            = "lsphillips.projects@gmail.com"
	is_public               = true
}

output "repository_url" {
	value = module.test_package_repository.package_repository_url
}
