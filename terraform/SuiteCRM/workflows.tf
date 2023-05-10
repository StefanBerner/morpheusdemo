resource "morpheus_provisioning_workflow" "SuiteCRMDBMN" {
  name        = "SuiteCRMDB - Multi Node"
  //description = "Terraform provisioning workflow example"
  platform    = "linux"
  visibility  = "private"
  task {
    task_id    = morpheus_shell_script_task.suitecrmdbmn.id
    task_phase = "provision"
  }
}
resource "morpheus_provisioning_workflow" "SuiteCRMAPPMN" {
  name        = "SuiteCRMApp - Multi Node"
  //description = "Terraform provisioning workflow example"
  platform    = "linux"
  visibility  = "private"
  task {
    task_id    = morpheus_shell_script_task.suitecrmappmn.id
    task_phase = "provision"
  }
  task {
    task_id    = morpheus_shell_script_task.suitecrmapacherestart.id
    task_phase = "provision"
  } 
}