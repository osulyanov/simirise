# frozen_string_literal: true

class User < ApplicationRecord
  enum state: { pending: 0, rejected: 1, approved: 2 }

  has_one_attached :photo

  has_and_belongs_to_many :tags
  has_many :tickets
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
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
