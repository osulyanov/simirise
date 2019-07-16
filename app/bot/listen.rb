# frozen_string_literal: true

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(
  access_token: Rails.application.credentials.access_token,
  subscribed_fields: %w[feed mention name]
)

Facebook::Messenger::Profile.set({
                                   greeting: [
                                     {
                                       locale: 'default',
                                       text: 'Хей! Это Rise Entertainment Bot'
                                     }
                                   ],
                                   get_started: {
                                     payload: 'get_started'
                                   }
                                 }, access_token: Rails.application.credentials.access_token)

# message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# message.sender      # => { 'id' => '1008372609250235' }
# message.sent_at     # => 2016-04-22 21:30:36 +0200
# message.text        # => 'Hello, bot!'

Bot.on :message do |message|
  bot = Lola.new(message.sender, message.text)
  sender = get_sender_profile(message.sender)

  puts "! ! ! sender #{sender.inspect}"

  bot.ask
end

Bot.on :postback do |postback|
  payload = postback.payload
  parsed_payload = valid?(payload) ? JSON.parse(payload) : payload

  puts "! ! ! postback: #{parsed_payload.inspect}"

  bot = Lola.new(postback.sender, parsed_payload)

  if parsed_payload && parsed_payload['id']
    bot.send(parsed_payload['id'])
  else
    bot.send(parsed_payload)
  end
end

def valid?(json)
  JSON.parse(json)
  true
rescue StandardError
  false
end

def get_sender_profile(sender)
  request = HTTParty.get(
    "https://graph.facebook.com/v3.3/#{sender['id']}",
    query: {
      access_token: Rails.application.credentials.access_token,
      fields: 'first_name,last_name,gender,profile_pic'
    }
  )

  request.parsed_response
end
