terraform {
	required_providers {
		github = {
			source  = "integrations/github"
			version = ">= 5.0"
		}
	}
}

# Local Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

locals {
	version        = "2.0.0"
	temp_directory = "${path.root}/.terraform/tmp"
}

locals {
	file_model = {
		package_name            = var.package_name
		package_description     = var.package_description
		is_public               = var.is_public
		is_browser_package      = var.is_browser_package
		is_node_package         = var.is_node_package
		is_cli_package          = var.is_cli_package
		supported_node_versions = var.supported_node_versions
		author_name             = var.author_name
		author_email            = var.author_email
		module_version          = local.version
		time                    = timestamp()
	}
}

# Repository
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "github_repository" "repository" {
	name                        = var.package_name
	description                 = var.package_description
	has_issues                  = true
	has_discussions             = false
	has_projects                = false
	has_wiki                    = false
	is_template                 = false
	allow_merge_commit          = false
	allow_squash_merge          = true
	allow_rebase_merge          = false
	allow_auto_merge            = true
	squash_merge_commit_title   = "PR_TITLE"
	squash_merge_commit_message = "BLANK"
	delete_branch_on_merge      = true
	auto_init                   = true
	archived                    = false
	archive_on_destroy          = false
	visibility                  = var.is_public ? "public" : "private"
}

# Issue Labels
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "github_issue_label" "bug_issue_label" {
	repository  = github_repository.repository.name
	name        = "bug"
	color       = "d73a4a"
	description = "Something isn't working"
}

resource "github_issue_label" "dependencies_issue_label" {
	repository  = github_repository.repository.name
	name        = "dependencies"
	color       = "0366d6"
	description = "Pull requests that update a dependency file"
}

# `main` Branch
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "github_branch_default" "main_branch_as_default" {
	repository = github_repository.repository.name
	branch     = "main"
	rename     = false
}

resource "github_branch_protection" "main_branch_protection_rules" {
	repository_id                   = github_repository.repository.node_id
	pattern                         = "main"
	enforce_admins                  = false
	require_signed_commits          = false
	required_linear_history         = false
	require_conversation_resolution = true
	allows_deletions                = false
	allows_force_pushes             = false
	blocks_creations                = false
	lock_branch                     = false
	push_restrictions               = []

	required_status_checks {
		strict   = true
		contexts = var.is_node_package ? [for node_version in var.supported_node_versions : "Build & Test on Node v${node_version}"] : ["Build & Test"]
	}

	required_pull_request_reviews {
		dismiss_stale_reviews           = true
		restrict_dismissals             = false
		dismissal_restrictions          = []
		required_approving_review_count = 1
		require_last_push_approval      = false
		pull_request_bypassers          = []
	}
}

# Generate `package.json` & `package-lock.json` File
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "local_file" "local_package_file" {
	filename = "${local.temp_directory}/package.json"
	content  = templatefile("${path.module}/templates/package.json.tftpl", local.file_model)
}

data "external" "local_package_lock_file" {
	program     = ["node", "${ abspath(path.module) }/scripts/generate-package-lock-file.js"]
	working_dir = local.temp_directory

	depends_on = [
		local_file.local_package_file
	]
}

# Repository Files
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "github_repository_file" "package_file" {
	repository          = github_repository.repository.name
	branch              = "main"
	commit_message      = "[npm-package-generator] Created `package.json` file."
	overwrite_on_create = true
	file                = "package.json"
	content             = local_file.local_package_file.content

	lifecycle {
		ignore_changes = all
	}
}

resource "github_repository_file" "package_lock_file" {
	repository          = github_repository.repository.name
	branch              = "main"
	commit_message      = "[npm-package-generator] Created `package-lock.json` file."
	overwrite_on_create = true
	file                = "package-lock.json"
	content             = data.external.local_package_lock_file.result.packageLockFile

	lifecycle {
		ignore_changes = all
	}
}

resource "github_repository_file" "package_startup_files" {
	for_each = toset(
		concat([
			"lib/index.js",
			"tests/index.test.js",
			"index.d.ts",
			"README.md",
			"CHANGELOG.md",
			"rollup.config.js",
			".eslintrc",
			"tests/.eslintrc"
		], var.is_cli_package ? [
			"cli/index.js",
			"cli/.eslintrc"
		] : [])
	)

	repository          = github_repository.repository.name
	branch              = "main"
	commit_message      = "[npm-package-generator] Created `${ replace(each.value, "index", var.package_name) }` file."
	overwrite_on_create = true
	file                = replace(each.value, "index", var.package_name)
	content             = templatefile("${ path.module }/templates/${ each.value }.tftpl", local.file_model)

	lifecycle {
		ignore_changes = all
	}
}

resource "github_repository_file" "package_standard_files" {
	for_each = toset([
		".editorconfig",
		".gitignore",
		".npmrc",
		"LICENSE.txt",
		".github/workflows/build.yml",
		".github/dependabot.yml",
		".github/workflows/dependabot.yml"
	])

	repository          = github_repository.repository.name
	branch              = "main"
	commit_message      = "[npm-package-generator] Created `${ replace(each.value, "index", var.package_name) }` file."
	overwrite_on_create = false
	file                = replace(each.value, "index", var.package_name)
	content             = templatefile("${ path.module }/templates/${ each.value }.tftpl", local.file_model)
}
