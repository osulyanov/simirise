# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy

  scope :paid, -> { where("status ->> 'name' = ?", 'paid').or(where("status ->> 'name' = ?", 'ok')) }
  scope :free, -> { where("status ->> 'name' = ?", 'ok') }
  scope :not_free, -> { where("status ->> 'name' = ?", 'paid') }

  def self.to_csv
    attributes = %w[id mail promocodes timepad_id payment.amount status.name status.title]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |order|
        csv << attributes.flat_map do |attr|
          name, key = attr.split('.')
          value = key ? order.send(name).dig(key) : order.send(name)
          value.is_a?(Array) ? value.uniq.join(';') : value
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: orders
#
#  id          :bigint(8)        not null, primary key
#  answers     :jsonb
#  imported_at :datetime
#  mail        :string
#  meta        :jsonb
#  payment     :jsonb
#  promocodes  :string           default([]), is an Array
#  referrer    :jsonb
#  status      :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint(8)
#  timepad_id  :integer
#
# Indexes
#
#  index_orders_on_event_id     (event_id)
#  index_orders_on_imported_at  (imported_at)
#
