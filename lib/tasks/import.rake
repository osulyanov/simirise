# frozen_string_literal: true

namespace :import do
  task events: :environment do
    timepad = Timepad.new
    timepad_events = timepad.events&.result&.dig('values') || []
    timepad_events.each do |te|
      event = Event.find_or_initialize_by(timepad_id: te['id'])
      %i[starts_at ends_at name questions moderation_status access_status].each do |k, v|
        event.assign_attributes :"#{k}" => v
      end
      event.country = te['location']['country']
      event.city = te['location']['city']
      event.coordinates = te['location']['coordinates'].join(',')
      event.save!
      te['ticket_types'].each do |tt|
        ticket_type = event.ticket_types.find_or_initialize_by(timepad_id: tt.delete('id'))
        tt.each { |k, v| ticket_type.assign_attributes :"#{k}" => v }
        ticket_type.name = tt['name']
        ticket_type.save!
      end
    end
  end
end
