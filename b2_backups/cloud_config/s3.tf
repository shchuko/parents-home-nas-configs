resource "b2_bucket" "data_backups" {
  bucket_name = "parents-nas-data-backups"
  bucket_type = "allPrivate"
}