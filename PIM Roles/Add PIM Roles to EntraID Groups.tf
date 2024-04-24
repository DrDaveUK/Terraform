locals {

  azure_roles = [
    "Global Administrator",
    "Global Reader",
    "Groups Administrator",
    "Helpdesk Administrator",
    "Intune Administrator",
    "User Administrator",
    "Privileged Authentication Administrator",
    "Security Administrator",
    "Security Reader"
  ]

}

## Create AD Groups which are assignable to a role
resource "azuread_group" "pim_groups" {
  for_each                = toset(local.azure_roles)
  display_name            = "Entra - Role - PIM - ${each.key}"
  description             = "PIM Role Group for ${each.key}"
  owners                  = [data.azuread_service_principal.github-app.object_id]
  members                 = []
  prevent_duplicate_names = true
  mail_enabled            = false
  security_enabled        = true
  assignable_to_role      = true
}

## Create a resource of all of the azure_roles specified above
resource "azuread_directory_role" "pim_roles" {
  for_each     = toset(local.azure_roles)
  display_name = each.key
}

### Option 1 -- Eligible Roles
## Group members need to use PIM to assign permissions to their identity
resource "azuread_directory_role_eligibility_schedule_request" "example" {
  for_each           = azuread_directory_role.pim_roles
  role_definition_id = each.value.template_id
  principal_id       = azuread_group.pim_groups[each.key].object_id
  directory_scope_id = "/"
  justification      = "Initial Setup Assignments"
}

### Option 2 - Prem assignment of role based on group membership
resource "azuread_directory_role_assignment" "example" {
  for_each            = azuread_directory_role.pim_roles
  role_id             = each.value.object_id
  principal_object_id = azuread_group.pim_groups[each.key].object_id
}
