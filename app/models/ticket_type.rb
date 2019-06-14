# frozen_string_literal: true

class TicketType < ApplicationRecord
  belongs_to :event
end

# == Schema Information
#
# Table name: ticket_types
#
#  id                  :bigint(8)        not null, primary key
#  ad_partner_profit   :integer
#  attended            :integer
#  buy_amount_max      :integer
#  buy_amount_min      :integer
#  description         :string
#  is_active           :boolean
#  is_promocode_locked :boolean
#  limit               :integer
#  name                :string
#  price               :integer
#  public_key          :string
#  remaining           :integer
#  sale_ends_at        :datetime
#  sale_starts_at      :datetime
#  send_personal_links :boolean
#  sold                :integer
#  status              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  event_id            :bigint(8)
#  timepad_id          :integer
#
# Indexes
#
#  index_ticket_types_on_event_id  (event_id)
#
