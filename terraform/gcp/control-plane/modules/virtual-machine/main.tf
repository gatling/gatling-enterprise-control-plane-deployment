locals {
  command = join(" ", var.command)
}

resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-113-18244-85-49"
    }
  }

  network_interface {
    network = var.network
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
    sudo mkdir -p /etc/control-plane
    sudo touch /etc/control-plane/control-plane.conf

    toolbox gcloud version
    toolbox gcloud secrets versions access latest --secret=${var.secret_name} | sudo tee /etc/control-plane/control-plane.conf

    sudo docker run -d --name control-plane -v /etc/control-plane/control-plane.conf:/app/conf/control-plane.conf -p 8080:8080 ${var.image} ${local.command}
  EOF

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  confidential_instance_config {
    enable_confidential_compute = var.enable_confidential_compute
    confidential_instance_type = var.confidential_instance_type
  }

}
