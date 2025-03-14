namespace :notifications do
  desc "Send Slack Notifications"
  task send_notifications: :environment do
    Notification.where(sent: false).group_by(&:organization).each do |organization, notifications|
      grouped_notifications = notifications.group_by(&:title).compact_blank
      message_body = grouped_notifications.map do |title, group|
        "*#{title}*\n" + group.map { |n| "- #{n.description}" }.join("\n")
      end.join("\n\n")

      next if message_body.blank?

      sent = SlackNotifier.post_message(organization, "Notifications for #{organization.name}", message_body)

      notifications.each { |n| n.update(sent: sent) }
      sleep 1
    rescue => e
      Rails.logger.error "Failed to send notifications for #{organization.name}: #{e.message}"
    end
  end
end
