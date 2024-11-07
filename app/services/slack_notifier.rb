class SlackNotifier
  def self.post_message(organization, title, body)
    client = Slack::Web::Client.new(token: organization.slack_workspace_token)
    client.chat_postMessage(
      channel: "##{organization.slack_channel}",
      text: "Notification",
      blocks: set_block(title, body),
      as_user: true
    )
  rescue Slack::Web::Api::Errors::SlackError => e
    Rails.logger.error "Slack API error: #{e.message}"
    nil
  end

  private
    def self.set_block(title, body)
      [
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "*#{title}*"
          }
        },
        {
          type: "divider"
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: body
          }
        }
      ]
    end
end
