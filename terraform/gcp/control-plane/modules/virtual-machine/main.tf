locals {
  conf_file_name = "control-plane.conf"
  host_path      = "/etc/control-plane"
  mount_path     = "/app/conf"
  volume         = "-v ${local.host_path}/${local.conf_file_name}:${local.mount_path}/${local.conf_file_name}"
  env            = "-e CONTROL_PLANE_TOKEN=$CONTROL_PLANE_TOKEN"
  port           = length(var.private_package) > 0 ? "-p ${var.private_package.conf.server.port}:${var.private_package.conf.server.port}" : ""
  command        = join(" ", var.command)
  config_content = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = { %{for key, value in var.enterprise_cloud} ${key} = "${value}" %{endfor} }
      locations = [ %{for location in var.locations} ${jsonencode(location.conf)}, %{endfor} ]
      %{if length(var.private_package) > 0}repository = ${jsonencode(var.private_package.conf)}%{endif}
      %{for key, value in var.extra_content}${key} = "${value}"%{endfor}
    }
  EOF
}

resource "google_compute_instance" "default" {
  name             = var.name
  machine_type     = var.machine_type
  zone             = var.zone
  min_cpu_platform = var.min_cpu_platform

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-113-18244-85-49"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    dynamic "access_config" {
      for_each = var.enable_external_ip ? [1] : []
      content {
      }
    }
  }

  service_account {
    email  = var.service_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #! /bin/bash

    set -e
    
    toolbox gcloud version
    CONTROL_PLANE_TOKEN=$(toolbox gcloud secrets versions access latest --secret=${var.token_secret_name} || echo "SECRET_FETCH_FAILED")

    mkdir -p ${local.host_path}
    echo '${local.config_content}' | sudo tee ${local.host_path}/${local.conf_file_name}

    sudo docker run -d --name ${var.name} ${local.env} ${local.volume} ${var.image} ${local.port} ${local.command}
  EOF

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  confidential_instance_config {
    enable_confidential_compute = var.enable_confidential_compute
    confidential_instance_type  = var.confidential_instance_type
  }

}
