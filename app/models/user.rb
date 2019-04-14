# frozen_string_literal: true

class User < ApplicationRecord
  enum state: { pending: 0, rejected: 1, approved: 2 }

  has_one_attached :photo

  has_and_belongs_to_many :tags

  def self.tags
    all.pluck(:tags).flat_map { |t| t&.split(',') }.uniq
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  birth_date :date
#  comment    :text
#  email      :string
#  fb_link    :string
#  name       :string
#  phone      :string
#  state      :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
