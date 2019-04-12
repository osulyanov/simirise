# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { nil }
  end
end
