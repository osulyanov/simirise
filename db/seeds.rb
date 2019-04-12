# frozen_string_literal: true

unless AdminUser.any?
  AdminUser.create!(name: 'Oleg',
                    email: 'oleg@sulyanov.com',
                    password: 'rCJ9w>r}&kMev83',
                    password_confirmation: 'rCJ9w>r}&kMev83')
end
