resource "b2_bucket" "parents_nas_nextcloud" {
  bucket_name = "parents-nas-nextcloud"
  bucket_type = "allPrivate"
}