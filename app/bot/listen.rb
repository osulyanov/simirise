# frozen_string_literal: true

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(
  access_token: Rails.application.credentials.access_token,
  subscribed_fields: %w[feed mention name]
)

Facebook::Messenger::Profile.set({
                                   "persistent_menu": [
                                     {
                                       "locale": 'default',
                                       "composer_input_disabled": false,
                                       "call_to_actions": [
                                         {
                                           "type": 'postback',
                                           "title": 'Talk to an agent',
                                           "payload": 'CARE_HELP'
                                         },
                                         {
                                           "type": 'postback',
                                           "title": 'Outfit suggestions',
                                           "payload": 'CURATION'
                                         },
                                         {
                                           "type": 'web_url',
                                           "title": 'Shop now',
                                           "url": 'https://www.originalcoastclothing.com/',
                                           "webview_height_ratio": 'full'
                                         }
                                       ]
                                     }
                                   ],
                                   get_started: {
                                     payload: 'get_started'
                                   },
                                   greeting: [
                                     {
                                       locale: 'default',
                                       text: 'Хей {{user_full_name}}! Это Rise Entertainment Bot'
                                     }
                                   ]
                                 }, access_token: Rails.application.credentials.access_token)

def say_lola(sender, postback_id)
  bot = Lola.new(sender, postback_id)

  if bot.respond_to?(postback_id)
    bot.send(postback_id)
  else
    bot.call_custom_action
  end
end

Bot.on :message do |message|
  puts "MESSAGE: #{message.text} /// #{message.quick_reply} /// #{message.attachments}"

  say_lola(message.sender, message.quick_reply) if message.quick_reply
end

Bot.on :postback do |postback|
  payload = postback.payload
  parsed_payload = valid?(payload) ? JSON.parse(payload) : payload
  postback_id = parsed_payload && parsed_payload['id'] ? parsed_payload['id'] : parsed_payload

  puts "POSTBACK: #{parsed_payload.inspect}"

  say_lola(postback.sender, postback_id)
end

Bot.on :message_echo do |message_echo|
  message_echo.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
  message_echo.sender      # => { 'id' => '1008372609250235' }
  message_echo.seq         # => 73
  message_echo.sent_at     # => 2016-04-22 21:30:36 +0200
  message_echo.text        # => 'Hello, bot!'
  message_echo.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

  puts "ECHO: #{message_echo.inspect}"
end

Bot.on :optin do |optin|
  optin.sender    # => { 'id' => '1008372609250235' }
  optin.recipient # => { 'id' => '2015573629214912' }
  optin.sent_at   # => 2016-04-22 21:30:36 +0200
  optin.ref       # => 'CONTACT_SKYNET'

  puts "OPTIN: #{optin.ref}"
end

Bot.on :delivery do |delivery|
  delivery.ids       # => 'mid.1457764197618:41d102a3e1ae206a38'
  delivery.sender    # => { 'id' => '1008372609250235' }
  delivery.recipient # => { 'id' => '2015573629214912' }
  delivery.at        # => 2016-04-22 21:30:36 +0200
  delivery.seq       # => 37

  puts "Human was online at #{delivery.at}"
end

def valid?(json)
  JSON.parse(json)
  true
rescue StandardError
  false
end
