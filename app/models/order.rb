# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy
end

# == Schema Information
#
# Table name: orders
#
#  id         :bigint(8)        not null, primary key
#  answers    :jsonb
#  mail       :string
#  meta       :jsonb
#  payment    :jsonb
#  promocodes :string           default([]), is an Array
#  referrer   :jsonb
#  status     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint(8)
#  timepad_id :integer
#
# Indexes
#
#  index_orders_on_event_id  (event_id)
#
