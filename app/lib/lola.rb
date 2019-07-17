# frozen_string_literal: true

class Lola
  include Facebook::Messenger

  attr_accessor :sender, :payload, :source

  def initialize(sender, payload)
    @sender = sender
    @payload = payload
    file = File.read(Rails.root.join('app', 'bot', 'bot.json'))
    @source = JSON.parse(file).with_indifferent_access
  end

  def get_started
    profile = get_sender_profile(sender)
    # puts "profile=#{profile.inspect}"

    payload_jsons.each do |payload_json|
      puts "payload_json=#{payload_jsons}"

      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  def events
    payload_jsons.each do |payload_json|
      puts "payload_jsons=#{payload_json}"

      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  def call_custom_action
    payload_jsons.each do |payload_json|
      puts "payload_jsons=#{payload_json}"

      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  private

  def payload_jsons
    payload_name = payload && payload['id'] ? payload['id'] : payload

    puts "payload_name=#{payload_name}"

    source.dig(:payloads, payload_name).map { |p| p.merge(recipient: sender) }
  end

  def get_sender_profile(sender)
    request = HTTParty.get(
      "https://graph.facebook.com/v3.3/#{sender['id']}",
      query: {
        access_token: Rails.application.credentials.access_token,
        fields: 'id,name,profile_pic,gender'
      }
    )

    request.parsed_response
  end
end
