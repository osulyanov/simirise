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
      event.timepad_description = te['description_html']
      event.country = te['location']['country']
      event.city = te['location']['city']
      event.address = te['location']['address']
      event.coordinates = te['location']['coordinates'].reverse.join(',')
      event.save!
      te['ticket_types'].each do |tt|
        ticket_type = event.ticket_types.find_or_initialize_by(timepad_id: tt.delete('id'))
        tt.each { |k, v| ticket_type.assign_attributes :"#{k}" => v }
        ticket_type.save!
      end
    end
  end

  task orders: :environment do
    tp_import = TpImport.new
    tp_import.orders(Event.future)
  end

  task all_orders: :environment do
    tp_import = TpImport.new
    tp_import.orders(Event.all)
  end

  task users: :environment do
    path = Rails.root.join('db', 'seed_data', 'users.csv')
    file = File.read(path)
    users = CSV.parse(file, headers: true, col_sep: ';')
    users.each do |row|
      data = row.to_hash
      user = User.find_or_initialize_by(email: data['E-mail'])
      user.assign_attributes(name: [data['Имя'], data['Фамилия']].join(' '),
                             phone: data['Телефон'],
                             state: :approved)
      user.save!
    end
  end
end
