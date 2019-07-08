# frozen_string_literal: true

include Facebook::Messenger
require 'facebook/messenger'

begin
  Facebook::Messenger::Subscriptions.subscribe(access_token: Rails.application.credentials.access_token)
rescue Facebook::Messenger::Subscriptions::Error => e
  Rails.logger.info "ERR: #{e}"
end

# message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# message.sender      # => { 'id' => '1008372609250235' }
# message.sent_at     # => 2016-04-22 21:30:36 +0200
# message.text        # => 'Hello, bot!'

Bot.on :message do |_message|
  Bot.deliver({
                recipient: message.sender,
                message: {
                  text: message.text
                }
              }, access_token: Rails.application.credentials.access_token)
end
