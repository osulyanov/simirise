# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  birth_date             :date
#  phone                  :string
#  fb_link                :string
#  position               :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#


FactoryBot.define do
  factory :admin_user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { nil }
  end
end
