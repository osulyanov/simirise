# frozen_string_literal: true

class TicketTypesTicket < ApplicationRecord
  belongs_to :ticket
  belongs_to :ticket_type
end

# == Schema Information
#
# Table name: ticket_types_tickets
#
#  ticket_id      :bigint(8)        not null
#  ticket_type_id :bigint(8)        not null
#
