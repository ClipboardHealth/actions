locals {
  app_name  = "tmp-cbh-test-deploy-ecs"
  workspace = trimprefix("${var.TFC_WORKSPACE_NAME}", "${local.app_name}-")
  port      = 80

  tags = {
    temporary = true
    action    = "deploy-ecs"
    repo      = "https://github.com/ClipboardHealth/actions"
  }
}
