resource "b2_bucket" "parents_nas_nextcloud" {
  bucket_name = "parents-nas-nextcloud"
  bucket_type = "allPrivate"

  lifecycle_rules {
    file_name_prefix = ""
    days_from_hiding_to_deleting  = 1
    days_from_uploading_to_hiding = 0
  }
}