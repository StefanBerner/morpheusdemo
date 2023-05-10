resource "morpheus_git_integration" "SuiteCRM-git" {
  name               = "suiteCRM-git"
  enabled            = true
  url                = "https://github.com/peterj1974/suitecrm.git"
  default_branch     = "main"
  enable_git_caching = false
}
