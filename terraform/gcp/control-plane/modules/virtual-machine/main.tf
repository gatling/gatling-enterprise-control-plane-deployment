locals {
  conf_file_name   = "control-plane.conf"
  host_path        = "/etc/control-plane"
  mount_path       = "/app/conf"
  volume           = "-v ${local.host_path}/${local.conf_file_name}:${local.mount_path}/${local.conf_file_name}"
  environment_list = concat(["-e CONTROL_PLANE_TOKEN=$CONTROL_PLANE_TOKEN"], lookup(var.container, "environment", []))
  environment      = join(" ", local.environment_list)
  port             = "-p ${var.server.port}:${var.server.port}"
  command          = join(" ", var.container.command)
  config_content   = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = ${jsonencode(var.enterprise-cloud)}
      locations = [%{for location in var.locations} ${jsonencode(location.conf)}, %{endfor}]
      server = ${jsonencode(var.server)}
      %{if length(var.private-package) > 0}repository = ${jsonencode(var.private-package.conf)}%{endif}
      %{for key, value in var.extra-content}${key} = "${value}"%{endfor}
    }
  EOF
}

resource "google_compute_instance" "control_plane" {
  name             = var.name
  zone             = var.network.zone
  machine_type     = var.compute.machine-type
  min_cpu_platform = var.compute.min-cpu-platform

  boot_disk {
    initialize_params {
      image = var.compute.boot-disk-image
    }
  }

  network_interface {
    network    = var.network.network
    subnetwork = var.network.subnetwork
    dynamic "access_config" {
      for_each = var.network.enable-external-ip ? [1] : []
      content {}
    }
  }

  service_account {
    email  = var.service-email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #! /bin/bash

    set -e
    
    toolbox gcloud version
    CONTROL_PLANE_TOKEN=$(toolbox gcloud secrets versions access latest --secret=${var.token-secret-name} || echo "SECRET_FETCH_FAILED")

    mkdir -p ${local.host_path}
    echo '${local.config_content}' | sudo tee ${local.host_path}/${local.conf_file_name}

    sudo docker run -d --name ${var.name} ${local.environment} ${local.volume} ${var.container.image} ${local.port} ${local.command}
  EOF

  shielded_instance_config {
    enable_secure_boot          = var.compute.shielded.enable-secure-boot
    enable_vtpm                 = var.compute.shielded.enable-vtpm
    enable_integrity_monitoring = var.compute.shielded.enable-integrity-monitoring
  }

  confidential_instance_config {
    enable_confidential_compute = var.compute.confidential.enable
    confidential_instance_type  = var.compute.confidential.instance-type
  }
}
