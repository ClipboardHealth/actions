terraform {
  backend "remote" {
    organization = "clipboard-staffing"

    workspaces {
      prefix = "tmp-cbh-test-terraform-creation-"
    }
  }

  required_version = ">= 1.0.0"

  required_providers {
    fakewebservices = "~> 0.1"
  }
}
