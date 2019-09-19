# frozen_string_literal: true

require 'facebook/messenger'

class Listener
  include Facebook::Messenger

  Facebook::Messenger::Subscriptions.subscribe(
    access_token: Rails.application.credentials.access_token,
    subscribed_fields: %w[feed mention name]
  )

  file = File.read(Rails.root.join('app', 'bot', 'bot.json'))
  @source = JSON.parse(file).with_indifferent_access
  @users ||= {}

  Facebook::Messenger::Profile.set(@source.dig(:profile), access_token: Rails.application.credentials.access_token)

  def self.say_lola(user, postback_id)
    bot = Lola.new(user, postback_id)

    if bot.respond_to?(postback_id)
      bot.send(postback_id)
    else
      bot.call_custom_action
    end
  end

  def self.get_sender_profile(fb_id)
    request = HTTParty.get(
      "https://graph.facebook.com/v3.3/#{fb_id}",
      query: {
        access_token: Rails.application.credentials.access_token,
        fields: 'id,name,profile_pic,gender'
      }
    )

    request.parsed_response
  end

  def self.asked?(sender, question_payloads)
    last_message = fuser(sender['id']).messages&.last&.dig('message', 'text')

    payload_texts = if question_payloads.is_a?(Array)
                      question_payloads.flat_map do |question_payloads|
                        @source.dig(:payloads, question_payloads).map { |c| c.dig(:message, :text) }
                      end
                    else
                      @source.dig(:payloads, question_payloads).map { |c| c.dig(:message, :text) }
                    end

    last_message.present? && payload_texts.include?(last_message)
  end

  def self.fuser(fb_id = nil)
    Rails.logger.info "> self.fuser(#{fb_id})"
    @users[fb_id] ||= user_find_or_create(fb_id).reload
  end

  def self.user_find_or_create(fb_id)
    Rails.logger.info "> self.user_find_or_create(#{fb_id})"
    User.find_or_initialize_by(fb_id: fb_id).tap do |u|
      unless u.persisted?
        u.source = 'messenger'
        u.save!
        user_update_profile(u)
      end
    end
  end

  def self.user_update_profile(user)
    return unless profile = get_sender_profile(user.fb_id)

    user.name = profile['name']
    if profile['profile_pic'] && avatar = open(profile['profile_pic'])
      user.photo.attach(io: avatar, filename: 'profile_pic.jpg')
    end
    user.save!
  end

  Bot.on :message do |message|
    Rails.logger.info " > MESSAGE: #{message.text} /// #{message.quick_reply} /// #{message.attachments}"

    if message.quick_reply
      say_lola(fuser(message.sender['id']), message.quick_reply)
    elsif asked?(message.sender, :contact_start)
      Rails.logger.info ' > SAVE MESSAGE'
      fuser(message.sender)
      # Send to admin

      say_lola(fuser(message.sender['id']), 'contact_end')
    elsif asked?(message.sender, :moderate)
      Rails.logger.info ' > SEND SMS'
      fuser(message.sender).send_sms_code(message.text)

      say_lola(fuser(message.sender['id']), 'sms_check')
    elsif asked?(message.sender, %i[sms_check sms_resend])
      Rails.logger.info ' > CHECK SMS'
      if fuser(message.sender).sms_code == message.text
        fuser(message.sender['id']).inreview!
        say_lola(fuser(message.sender['id']), 'wait')
      else
        say_lola(fuser(message.sender['id']), 'sms_wrong')
      end
    else
      say_lola(fuser(message.sender['id']), 'contact_start')
    end
  end

  Bot.on :postback do |postback|
    payload = postback.payload
    parsed_payload = valid?(payload) ? JSON.parse(payload) : payload
    postback_id = parsed_payload && parsed_payload['id'] ? parsed_payload['id'] : parsed_payload

    Rails.logger.info " > POSTBACK: #{parsed_payload.inspect}"

    fuser(postback.sender['id']).send_sms_code if postback_id == 'sms_resend'

    say_lola(fuser(postback.sender['id']), postback_id)
  end

  Bot.on :message_echo do |message_echo|
    Rails.logger.info " > ECHO: #{message_echo.inspect}"

    fuser(message_echo.recipient['id']).add_message(message_echo.messaging)
  end

  def self.valid?(json)
    JSON.parse(json)
    true
  rescue StandardError
    false
  end
end
