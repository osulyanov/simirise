# frozen_string_literal: true

class User < ApplicationRecord
  enum state: { pending: 0, rejected: 1, approved: 2 }

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
#  name       :string
#  phone      :string
#  state      :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#
