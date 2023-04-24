module "test_package_repository" {
	source                  = "github.com/lsphillips/npm-package-generator"
	package_name            = "test-package"
	package_description     = "This is a test package that can only be used in a NodeJS environment."
	is_browser_package      = false
	is_node_package         = true
	is_cli_package          = true
	supported_node_versions = [16, 18]
	author_name             = "Luke Phillips"
	author_email            = "lsphillips.projects@gmail.com"
	is_public               = false
}

output "repository_url" {
	value = module.test_package_repository.package_repository_url
}
