# frozen_string_literal: true

namespace :import do
  task events: :environment do
    timepad = Timepad.new
    timepad_events = timepad.events&.result&.dig('values') || []
    timepad_events.each do |te|
      event = Event.find_or_initialize_by(timepad_id: te['id'])
      %w[starts_at ends_at name questions moderation_status access_status].each do |k|
        event.assign_attributes :"#{k}" => te[k]
      end
      event.country = te['location']['country']
      event.city = te['location']['city']
      event.coordinates = te['location']['coordinates'].join(',')
      event.save!
      te['ticket_types'].each do |tt|
        ticket_type = event.ticket_types.find_or_initialize_by(timepad_id: tt.delete('id'))
        tt.each { |k, v| ticket_type.assign_attributes :"#{k}" => v }
        ticket_type.save!
      end
    end
  end

  task orders: :environment do
    timepad = Timepad.new
    Event.future.find_each do |event|
      puts "import #{event.name}"
      processed = 0
      total = 0
      loop do
        puts "orders #{processed}-#{processed + 250} of #{total}"
        timepad_res = timepad.orders(event.timepad_id)&.result
        timepad_orders = timepad_res&.dig('values') || []
        total = timepad_res&.dig('total') || 0
        processed += timepad_orders.size
        timepad_orders.each do |to|
          order = event.orders.find_or_initialize_by(timepad_id: to.delete('id'))
          to.delete('subscribed_to_newsletter')
          to.delete('_links')
          tickets = to.delete('tickets')
          to.each { |k, v| order.assign_attributes :"#{k}" => v }
          order.save!
          tickets.each do |t|
            ticket = order.tickets.find_or_initialize_by(timepad_id: t.delete('id'))
            ticket.ticket_type_id = t.delete('ticket_type')['id']
            t.delete('personal_link')
            t.each { |k, v| ticket.assign_attributes :"#{k}" => v }
            ticket.save!
          end
        end
        break unless total > processed
      end
    end
  end
end
