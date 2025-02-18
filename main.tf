terraform {
  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.1.2"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }

    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "abbey" {
  # Configuration options
}

provider "null" {
  # Configuration options
}

provider "random" {
  # Configuration options
}

resource "abbey_grant_kit" "null_grant" {
  name = "Null grant"
  description = <<-EOT
    Grants access to a Null Resource.
    This Grant Kit uses a single-step Grant Workflow that requires only a single reviewer
    from a list of reviewers to approve access.
  EOT

  workflow = {
    steps = [
      {
        reviewers = {
          # Typically uses your Primary Identity.
          # For this local example, you can pass in an arbitrary string.
          # For more information on what a Primary Identity is, visit https://docs.abbey.so.
          one_of = ["replace-me@example.com"]
        }
      }
    ]
  }

  output = {
    # Replace with your own path pointing to where you want your access changes to manifest.
    # Path is an RFC 3986 URI, such as `github://{organization}/{repo}/path/to/file.tf`.
    location = "github://replace-me-with-organization/replace-me-with-repo/access.tf"
    append = <<-EOT
      resource "null_resource" "null_grant_${random_pet.random_pet_name.id}" {
      }
    EOT
  }
}

resource "abbey_identity" "user_1" {
  name = "User 1"

  linked = jsonencode({
    abbey = [
      {
        type  = "AuthId"
        value = "replace-me@example.com"
      }
    ]
  })
}

resource "random_pet" "random_pet_name" {
  length = 5
  separator = "_"
}
