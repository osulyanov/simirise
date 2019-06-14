# frozen_string_literal: true

class AdminUser < ApplicationRecord
  ACCESS_LEVELS = %w[user tag event admin_user setting].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_one_attached :photo
end

# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint(8)        not null, primary key
#  access                 :text             default([]), is an Array
#  birth_date             :date
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  fb_link                :string
#  name                   :string
#  phone                  :string
#  position               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#
