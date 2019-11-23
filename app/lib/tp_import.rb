# frozen_string_literal: true

class TpImport
  def initialize; end

  def orders(events)
    current_time = Time.zone.now
    timepad = Timepad.new
    events.find_each do |event|
      puts " > import #{event.name}"
      processed = 0
      total = 0
      loop do
        timepad_res = timepad.orders(event.timepad_id, skip: processed)&.result
        timepad_orders = timepad_res&.dig('values') || []
        total = timepad_res&.dig('total') || 0
        puts " > orders #{processed}-#{processed + 250} of #{total}"
        processed += timepad_orders.size
        timepad_orders.each do |to|
          order = event.orders.find_or_initialize_by(timepad_id: to.delete('id'))
          order.imported_at = current_time
          to.delete('subscribed_to_newsletter')
          to.delete('_links')
          tickets = to.delete('tickets')
          to.each { |k, v| order.assign_attributes :"#{k}" => v }
          order.save!
          tickets.each do |t|
            ticket = order.tickets.find_or_initialize_by(timepad_id: t.delete('id'))
            ticket.imported_at = current_time
            ticket.ticket_type_id = t.delete('ticket_type')['id']
            t.delete('personal_link')
            t.each { |k, v| ticket.assign_attributes :"#{k}" => v }
            ticket.user = user_for_ticket(ticket)
            if ticket.valid?
              ticket.save!
            else
              puts " > ERRORS: #{ticket.errors.full_messages}\n" \
                   " > DATA: #{tickets.inspect}"
            end
          end
          order.tickets.where.not(imported_at: current_time).destroy_all
        end
        event.orders.where.not(imported_at: current_time).destroy_all
        break unless total > processed
      end
    end
  end

  def user_for_ticket(ticket)
    answers = ticket.answers.dup
    User.find_or_initialize_by(email: answers.delete('mail')).tap do |user|
      user.name = [answers.delete('name'), answers.delete('surname')].join(' ')
      user.phone = answers.delete('phone')
      user.answers = (user.answers.is_a?(Hash) ? user.answers : {})
                     .merge(named_answers(answers, ticket.order.event))
                     .uniq
      user.state = :approved if %w[ok paid].include?(ticket.order.status['name'])
      user.state = :rejected if %w[rejected inactive].include?(ticket.order.status['name'])
      user.save!
    end
  end

  def named_answers(answers, event)
    answers.map do |field_id, answer|
      title = event.questions.select { |q| q['field_id'] == field_id }.first&.dig('name')
      { title || field_id => answer }
    end.reduce({}, :merge)
  end
end
