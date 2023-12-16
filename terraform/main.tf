resource "google_compute_firewall" "firewall" {
  name    = "gritfy-firewall-externalssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
}

resource "google_compute_firewall" "webserverrule" {
  name    = "gritfy-webserver"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["webserver"]
}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "vm-public-address"
  project = var.project_id
  region = var.region
  depends_on = [ google_compute_firewall.firewall ]
}

resource "google_compute_instance" "dev" {
  name         = "demovm"
  machine_type = "e2-medium"
  zone         = "${var.region}-b"
  tags         = ["externalssh","webserver"]
  boot_disk {
    initialize_params {
      image = "debian-12"
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  # Ensure firewall rule is provisioned before server, so SSH doesn't fail.
  depends_on = [ google_compute_firewall.firewall, google_compute_firewall.webserverrule ]
  metadata_startup_script = "echo test > hello"

  metadata = {
    "ssh-keys" = <<EOT
      dev:${var.ssh_key}"
     EOT
  }
}
