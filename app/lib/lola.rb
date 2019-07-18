# frozen_string_literal: true

class Lola
  include Facebook::Messenger

  attr_accessor :user, :payload, :source

  def initialize(user, payload)
    @user = user
    @payload = payload
    file = File.read(Rails.root.join('app', 'bot', 'bot.json'))
    @source = JSON.parse(file).with_indifferent_access
  end

  def get_started
    payload_jsons.each do |payload_json|
      puts "payload_json=#{payload_jsons}"

      user.add_message(payload_json)
      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  def events
    payload_jsons.each do |payload_json|
      puts "payload_jsons=#{payload_json}"

      user.add_message(payload_json)
      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  def call_custom_action
    payload_jsons.each do |payload_json|
      puts "payload_jsons=#{payload_json}"

      user.add_message(payload_json)
      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  private

  def payload_jsons
    payload_name = payload && payload['id'] ? payload['id'] : payload

    puts "payload_name=#{payload_name}"

    source.dig(:payloads, payload_name).map { |p| p.merge(recipient: { id: user.fb_id }) }
  end
end
