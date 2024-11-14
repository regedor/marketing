namespace :notifications do
  desc "Send Slack Notifications"
  task send_notifications: :environment do
    Notification.where(sent: false).each do |notification|
      if SlackNotifier.post_message(notification.organization, notification.title, notification.description)
        notification.update(sent: true)
      end
    end
  end
end
