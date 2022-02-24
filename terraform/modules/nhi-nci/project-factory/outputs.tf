output "project" {
  description = "Project name and id that was created."
  value = {
    id   = module.project-factory.project_id
    name = module.project-factory.name
  }
}