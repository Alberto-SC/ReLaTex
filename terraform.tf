provider "google" {
  project = "your-project-id"
  region  = "your-region"
}

resource "google_storage_bucket" "pdf_bucket" {
  name     = "your-pdf-bucket-name"
  location = "your-location"
}

resource "google_storage_bucket_object" "pdf_resume" {
  name   = "resume.pdf"
  bucket = google_storage_bucket.pdf_bucket.name
  source = "./" // You can set this to an initial PDF file
}

resource "google_cloudfunctions_function" "update_pdf" {
  name         = "update-pdf-function"
  runtime      = "nodejs14"
  description  = "Update PDF in GCS bucket on GitHub commit"
  entry_point  = "updatePdf"
  source_archive_bucket = google_storage_bucket.pdf_bucket.name
  source_archive_object = "path/to/your/cloud-function-source-code.zip"
  trigger_http = true
  available_memory_mb = 256
}

resource "google_cloudfunctions_function_iam_binding" "update_pdf_iam_binding" {
  project = google_cloudfunctions_function.update_pdf.project
  region  = google_cloudfunctions_function.update_pdf.region
  cloud_function = google_cloudfunctions_function.update_pdf.name
  role    = "roles/cloudfunctions.invoker"
  members = [
    "serviceAccount:${google_cloudfunctions_function.update_pdf.service_account_email}",
  ]
}

resource "google_cloudfunctions_function_iam_binding" "github_webhook_iam_binding" {
  project = google_cloudfunctions_function.update_pdf.project
  region  = google_cloudfunctions_function.update_pdf.region
  cloud_function = google_cloudfunctions_function.update_pdf.name
  role    = "roles/cloudfunctions.invoker"
  members = [
    "serviceAccount:cloud-build@your-project-id.iam.gserviceaccount.com",
  ]
}
