class SlackNotifier
  def self.post_message(organization, title, body)
    if organization.slack_workspace_token.nil? || organization.slack_channel.nil? || organization.slack_workspace_token.blank?
      false
    else
      begin
        client = Slack::Web::Client.new(token: organization.slack_workspace_token)
        slack_channel = organization.slack_channel.start_with?("#") ? organization.slack_channel : "##{organization.slack_channel}"

        client.chat_postMessage(
          channel: slack_channel,
          text: "Notification",
          blocks: set_block(title, body),
          as_user: true
        )&.dig("ok")
      rescue Slack::Web::Api::Errors::SlackError => e
        Rails.logger.error "Slack API error: #{e.message}"
        false
      rescue StandardError => e
        Rails.logger.error "Unexpected error in post_message: #{e.message}"
        false
      end
    end
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
