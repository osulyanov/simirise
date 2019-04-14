# frozen_string_literal: true

class Tag < ApplicationRecord
  has_and_belongs_to_many :users
end

# == Schema Information
#
# Table name: tags
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
