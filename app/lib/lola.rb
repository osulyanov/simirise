# frozen_string_literal: true

class Lola
  include Facebook::Messenger

  attr_accessor :user, :payload, :source, :obj_id

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
    payload_name, obj_id = (payload && payload['id'] ? payload['id'] : payload).split('|')

    source.dig(:payloads, payload_name)
          .map { |p| process_payload(p, obj_id) }
          .map { |p| p.merge(recipient: { id: user.fb_id }) }
  end

  def process_payload(orig_payload, obj_id)
    if new_payload = orig_payload.dig(:template)
      case orig_payload.dig(:type)
      when 'elements'
        elements_template = new_payload['message']['attachment']['payload'].delete(:elements)
        model = orig_payload.dig(:data_source, :model).constantize
        scope = orig_payload.dig(:data_source, :scope)
        objects = model.send(scope)
        elements = objects.map do |obj|
          set_elements_vars(obj, elements_template)
        end
        new_payload['message']['attachment']['payload']['elements'] = elements
      when 'buttons'
        model = orig_payload.dig(:data_source, :model).constantize
        obj = model.find(obj_id)
        buttons = set_buttons_vars(obj, new_payload['message']['attachment']['payload']['buttons'])
        new_payload['message']['attachment']['payload']['buttons'] = buttons
      when 'quick_replies'
        quick_replies = new_payload['message'].delete(:quick_replies)
        model = orig_payload.dig(:data_source, :model).constantize
        obj = model.find(obj_id)
        quick_replies = quick_replies.map do |qr|
          qr.tap do |qr|
            qr['payload'].sub! ':id', obj.id.to_s
          end
        end
        new_payload['message']['quick_replies'] = quick_replies
      else
        model = orig_payload.dig(:data_source, :model).constantize
        obj = model.find(obj_id)
        new_payload['message']['text'] = obj.send(new_payload['message']['text'])
      end

      puts "new_payload=#{new_payload.inspect}"

      new_payload
    else
      orig_payload
    end
  end

  def set_elements_vars(obj, template)
    template.tap do |t|
      t['title'] = obj.send(t['title']) if t['title']
      t['image_url'] = obj.send(t['image_url']) if t['image_url']
      t['subtitle'] = obj.send(t['subtitle']) if t['subtitle']
      t['buttons'] = t['buttons'].map do |b|
        b.tap do |b|
          b['payload'].sub!(':id', obj.id.to_s) if b['payload']
          b['url'] = obj.send(b['url']) if b['url']
        end
      end
    end
  end

  def set_buttons_vars(obj, buttons)
    buttons.map do |b|
      b.tap do |b|
        b['url'] = obj.send(b['url']) if b['url']
      end
    end
  end
end
