# frozen_string_literal: true

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(
  access_token: Rails.application.credentials.access_token,
  subscribed_fields: %w[feed mention name]
)

file = File.read(Rails.root.join('app', 'bot', 'bot.json'))
@source = JSON.parse(file).with_indifferent_access

Facebook::Messenger::Profile.set(@source.dig(:profile), access_token: Rails.application.credentials.access_token)

def say_lola(user, postback_id)
  bot = Lola.new(user, postback_id)

  if bot.respond_to?(postback_id)
    bot.send(postback_id)
  else
    bot.call_custom_action
  end
end

def get_sender_profile(fb_id)
  request = HTTParty.get(
    "https://graph.facebook.com/v3.3/#{fb_id}",
    query: {
      access_token: Rails.application.credentials.access_token,
      fields: 'id,name,profile_pic,gender'
    }
  )

  request.parsed_response
end

def contact_started?(sender)
  last_message = user(sender['id']).messages&.last&.dig('message', 'text')
  contact_start_texts = @source.dig(:payloads, :contact_start).map { |c| c.dig(:message, :text) }
  last_message.present? && contact_start_texts.include?(last_message)
end

def user(fb_id)
  @user ||= user_find_or_create(fb_id)
end

def user_find_or_create(fb_id)
  User.find_or_initialize_by(fb_id: fb_id).tap do |u|
    unless u.persisted?
      u.source = 'messenger'
      u.save!
      user_update_profile(u)
    end
  end
end

def user_update_profile(user)
  return unless profile = get_sender_profile(user.fb_id)

  user.name = profile['name']
  if profile['profile_pic'] && avatar = open(profile['profile_pic'])
    user.photo.attach(io: avatar, filename: 'profile_pic.jpg')
  end
  user.save!
end

Bot.on :message do |message|
  puts "MESSAGE: #{message.text} /// #{message.quick_reply} /// #{message.attachments}"

  if message.quick_reply
    say_lola(user(message.sender), message.quick_reply)
  elsif contact_started?(message.sender)
    puts 'SAVE MESSAGE'
    user(message.sender)
    # TODO: SAVE MESSAGE

    say_lola(user(message.sender), :contact_end)
  else
    say_lola(user(message.sender), :contact_start)
  end
end

Bot.on :postback do |postback|
  payload = postback.payload
  parsed_payload = valid?(payload) ? JSON.parse(payload) : payload
  postback_id = parsed_payload && parsed_payload['id'] ? parsed_payload['id'] : parsed_payload

  puts "POSTBACK: #{parsed_payload.inspect}"

  say_lola(user(postback.sender), postback_id)
end

Bot.on :message_echo do |message_echo|
  message_echo.id # => 'mid.1457764197618:41d102a3e1ae206a38'
  message_echo.sender # => { 'id' => '1008372609250235' }
  message_echo.seq # => 73
  message_echo.sent_at # => 2016-04-22 21:30:36 +0200
  message_echo.text # => 'Hello, bot!'
  message_echo.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

  puts "ECHO: #{message_echo.inspect}"

  user(message_echo.recipient['id']).add_message(message_echo.messaging)
end

Bot.on :optin do |optin|
  optin.sender # => { 'id' => '1008372609250235' }
  optin.recipient # => { 'id' => '2015573629214912' }
  optin.sent_at # => 2016-04-22 21:30:36 +0200
  optin.ref # => 'CONTACT_SKYNET'

  puts "OPTIN: #{optin.ref}"
end

Bot.on :delivery do |delivery|
  delivery.ids # => 'mid.1457764197618:41d102a3e1ae206a38'
  delivery.sender # => { 'id' => '1008372609250235' }
  delivery.recipient # => { 'id' => '2015573629214912' }
  delivery.at # => 2016-04-22 21:30:36 +0200
  delivery.seq # => 37

  puts "Human was online at #{delivery.at}"
end

def valid?(json)
  JSON.parse(json)
  true
rescue StandardError
  false
end
