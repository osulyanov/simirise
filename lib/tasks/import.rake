# frozen_string_literal: true

namespace :import do
  task events: :environment do
    timepad = Timepad.new
    timepad_events = timepad.events&.result&.dig('values') || []
    timepad_events.each do |te|
      event = Event.find_or_initialize_by(timepad_id: te['id'])
      event.starts_at = te['starts_at']
      event.ends_at = te['ends_at']
      event.name = te['name']
      event.country = te['location']['country']
      event.city = te['location']['city']
      event.coordinates = te['location']['coordinates'].join(',')
      event.questions = te['questions']
      event.moderation_status = te['moderation_status']
      event.access_status = te['access_status']
      event.save!
      te['ticket_types'].each do |tt|
        ticket_type = event.ticket_types.find_or_initialize_by(timepad_id: tt['id'])
        ticket_type.name = tt['name']
        ticket_type.description = tt['description']
        ticket_type.buy_amount_min = tt['buy_amount_min']
        ticket_type.buy_amount_max = tt['buy_amount_max']
        ticket_type.price = tt['price']
        ticket_type.is_promocode_locked = tt['is_promocode_locked']
        ticket_type.remaining = tt['remaining']
        ticket_type.sale_ends_at = tt['sale_ends_at']
        ticket_type.sale_starts_at = tt['sale_starts_at']
        ticket_type.public_key = tt['public_key']
        ticket_type.is_active = tt['is_active']
        ticket_type.ad_partner_profit = tt['ad_partner_profit']
        ticket_type.send_personal_links = tt['send_personal_links']
        ticket_type.sold = tt['sold']
        ticket_type.attended = tt['attended']
        ticket_type.limit = tt['limit']
        ticket_type.status = tt['status']
        ticket_type.save!
      end
    end
  end
end
