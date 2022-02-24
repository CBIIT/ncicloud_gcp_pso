output "name" {
  description = "Notification channel name that was created."
  value = google_monitoring_notification_channel.notification_channel.name
}