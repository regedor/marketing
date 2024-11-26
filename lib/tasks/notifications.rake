namespace :notifications do
  desc "Send Slack Notifications"
  task send_notifications: :environment do
    # {
    #   "org1":[notifications]
    #   "org2":[notifications]
    # }
    # {
    #   "org1":[
    #     ["title1","type1"]:[notifications],
    #     ["title1","type2"]:[notifications],
    #     ["title2","type1"]:[notifications],
    #   ]
    #   "org2":[notifications]
    # }
    Notification.where(sent: false).group_by(&:organization).map { |org_key, orgnotifications| { org_key: org_key, notifications: orgnotifications.group_by { |n| [ n.title, n.type_notification ] } } }.each do |org_notifications|
      messages = {
        organization: org_notifications[:org_key],
        descriptions: org_notifications[:notifications].map { |key, ttn| "- #{ttn[0].description}" }
      }
      if SlackNotifier.post_message(messages[:organization], "Notification for Organization #{messages[:organization].name}", messages[:descriptions].join("\n"))
        Notification.where(organization: messages[:organization]).update(sent: true)
      end
    end
  end
end
