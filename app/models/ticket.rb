# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :order
end

# == Schema Information
#
# Table name: tickets
#
#  id             :bigint(8)        not null, primary key
#  answers        :jsonb
#  attendance     :jsonb
#  codes          :jsonb
#  number         :string
#  place          :jsonb
#  price_nominal  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_id       :bigint(8)
#  ticket_type_id :bigint(8)
#  timepad_id     :integer
#
# Indexes
#
#  index_tickets_on_order_id        (order_id)
#  index_tickets_on_ticket_type_id  (ticket_type_id)
#