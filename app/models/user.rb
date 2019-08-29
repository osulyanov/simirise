# frozen_string_literal: true

class User < ApplicationRecord
  enum state: { pending: 0, rejected: 1, approved: 2, inreview: 3 }

  has_one_attached :photo

  has_and_belongs_to_many :tags
  has_many :tickets

  ransacker :event_id, formatter: proc { |event_id| ids_by_event(event_id) } do |parent|
    parent.table[:id]
  end

  def self.ids_by_event(event_id)
    ids = Event.find(event_id)
               .orders
               .includes(:tickets)
               .flat_map { |o| o.tickets.pluck :user_id }
    ids.present? ? ids : [0]
  end

  def add_message(message)
    mm = messages || []
    mm << message
    update_attribute :messages, mm
  end

  def send_sms_code(phone = nil)
    phone ||= self.phone
    code = Random.new.rand(100_000..999_999).to_s
    Devino.new.sms phone, "Код подтверждения #{code}"
    update_attributes phone: phone,
                      sms_code: code,
                      smsed_at: Time.zone.now
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  answers    :jsonb
#  birth_date :date
#  comment    :text
#  email      :citext
#  fb_link    :string
#  messages   :jsonb
#  name       :string
#  phone      :string
#  sms_code   :string
#  smsed_at   :datetime
#  source     :string
#  state      :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fb_id      :string
#
# Indexes
#
#  index_users_on_email  (email)
#  index_users_on_fb_id  (fb_id)
#
