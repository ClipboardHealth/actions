terraform {
  backend "remote" {
    organization = "clipboard-staffing"

    workspaces {
      prefix = "tmp-cbh-test-deploy-ecs-"
    }
  }

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      version = "~> 4.5.0"
    }
  }
}

data "terraform_remote_state" "networking" {
  backend = "remote"
  config = {
    organization = "clipboard-staffing"
    workspaces = {
      name = "cbh-networking-development"
    }
  }
}

data "terraform_remote_state" "ecs" {
  backend = "remote"
  config = {
    organization = "clipboard-staffing"
    workspaces = {
      name = "cbh-ecs-development"
    }
  }
}
