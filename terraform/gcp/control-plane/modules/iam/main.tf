locals {
  private_location_permissions = [
    "compute.disks.create",
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.list",
    "compute.instances.setLabels",
    "compute.instances.setMetadata",
    "compute.subnetworks.use",
    "compute.subnetworks.useExternalIp",
    "secretmanager.versions.access"
  ]

  private_package_permissions = [
    "storage.objects.create",
    "storage.objects.delete",
    "iam.serviceAccounts.signBlob"
  ]

  custom_image_permissions = [
    "compute.images.useReadOnly"
  ]

  instance_template_permissions = [
    "compute.instanceTemplates.useReadOnly"
  ]

  has_custom_image = anytrue([
    for location in var.locations : location.conf.machine.image.type == "custom"
  ])

  has_instance_template = anytrue([
    for location in var.locations : lookup(location.conf, "instance-template", null) != null
  ])

  has_private_package = length(var.private_package) > 0 ? true : false

  extra_permissions = concat(
    local.has_custom_image ? local.custom_image_permissions : [],
    local.has_instance_template ? local.instance_template_permissions : [],
    local.has_private_package ? local.private_package_permissions : []
  )

  permissions = concat(local.private_location_permissions, local.extra_permissions)
}

data "google_client_config" "current" {}

resource "random_string" "role_suffix" {
  length  = 2
  special = false
  upper   = false
}

resource "google_project_iam_custom_role" "custom_role" {
  role_id     = "${var.role_id}_${random_string.role_suffix.result}"
  title       = var.role_title
  description = var.role_description
  project     = data.google_client_config.current.project
  permissions = local.permissions
}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

resource "google_project_iam_member" "service_account_role_binding" {
  project = data.google_client_config.current.project
  role    = google_project_iam_custom_role.custom_role.name
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
