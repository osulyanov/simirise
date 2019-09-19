# frozen_string_literal: true

class Lola
  include Facebook::Messenger

  attr_accessor :user, :payload, :source, :obj_id

  def initialize(user, payload)
    @user = user
    puts " > Lola USER=#{user.inspect}"
    @payload = payload
    file = File.read(Rails.root.join('app', 'bot', 'bot.json'))
    @source = JSON.parse(file).with_indifferent_access
  end

  def get_started
    payload_jsons.each do |payload_json|
      puts " > payload_json=#{payload_jsons}"

      user.add_message(payload_json)
      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  def events
    payload_jsons.each do |payload_json|
      puts " > \n\npayload_jsons=#{payload_json}"

      user.add_message(payload_json)
      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  def call_custom_action
    payload_jsons.each do |payload_json|
      puts " > payload_jsons=#{payload_json}"

      user.add_message(payload_json)
      Bot.deliver(payload_json, access_token: Rails.application.credentials.access_token)
    end
  end

  private

  def payload_jsons
    payload_name, obj_id = (payload && payload['id'] ? payload['id'] : payload).split('|')

    source.dig(:payloads, payload_name)
          .map { |p| process_payload(p, obj_id) }
          .select(&:present?)
          .map { |p| p.merge(recipient: { id: user.fb_id }) }
  end

  def process_payload(orig_payload, obj_id)
    if new_payload = orig_payload.dig(:template)&.clone
      case orig_payload.dig(:type)
      when 'elements'
        if conditions_ok?(orig_payload)
          elements_template = new_payload['message']['attachment']['payload'].delete(:elements)
          model = orig_payload.dig(:data_source, :model).constantize
          scope = orig_payload.dig(:data_source, :scope)
          objects = model.send(scope)
          objects = objects.is_a?(Array) ? objects[0...10] : objects.limit(10)
          elements = objects.map do |obj|
            set_elements_vars(obj, elements_template.clone)
          end.select { |t| t['buttons'].present? }
          new_payload['message']['attachment']['payload']['elements'] = elements
        else
          new_payload = nil
        end
      when 'buttons'
        if conditions_ok?(orig_payload)
          model = orig_payload.dig(:data_source, :model).constantize
          obj = model.find(obj_id)
          buttons = set_buttons_vars(obj, new_payload['message']['attachment']['payload']['buttons'].clone)
          new_payload['message']['attachment']['payload']['buttons'] = buttons
        else
          new_payload = nil
        end
      when 'quick_replies'
        if conditions_ok?(orig_payload)
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
          new_payload = nil
        end
      else
        if conditions_ok?(orig_payload)
          model = orig_payload.dig(:data_source, :model).constantize
          obj = model.find(obj_id)
          new_payload['message']['text'] = obj_var(obj, new_payload['message']['text'])
        else
          new_payload = nil
        end
      end

      puts " > new_payload=#{new_payload.inspect}"

      new_payload
    else
      orig_payload if conditions_ok?(orig_payload)
    end
  end

  def set_elements_vars(obj, template)
    template.tap do |t|
      puts " > t=#{t.inspect}"
      t['title'] = obj_var(obj, t['title']) if t['title']

      if t['image_url'] && obj_var(obj, t['image_url']) =~ URI::DEFAULT_PARSER.make_regexp
        t['image_url'] = obj_var(obj, t['image_url'])
      else
        t.delete('image_url')
      end

      t['subtitle'] = obj_var(obj, t['subtitle']) if t['subtitle']
      t['buttons'] = t['buttons'].map do |button|
        button.clone.tap do |b|
          b['payload'].sub!(':id', obj.id.to_s) if b['payload']
          b['url'] = obj_var(obj, b['url']) if b['url']
        end
      end.select { |b| b['type'] != 'web_url' || b['url'] =~ URI::DEFAULT_PARSER.make_regexp }
    end
  end

  def set_buttons_vars(obj, buttons)
    buttons.map do |button|
      button.tap do |b|
        b['url'] = obj_var(obj, b['url']) if b['url']
      end
    end.select { |b| b['type'] != 'web_url' || b['url'] =~ URI::DEFAULT_PARSER.make_regexp }
  end

  def obj_var(obj, method)
    value = obj.send(method)
    value.present? ? value : '—'
  end

  def conditions_ok?(orig_payload)
    user_condition = orig_payload.dig(:user_condition)
    return true if user_condition.blank?

    @user.reload.send(user_condition)
  end
end
