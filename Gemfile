# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.4'

gem 'activeadmin', github: 'activeadmin/activeadmin'
gem 'activeadmin_addons', github: 'platanus/activeadmin_addons'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan', '~> 2.0'
gem 'devise', '> 4.x'
gem 'facebook-messenger'
gem 'httparty'
gem 'image_processing', '~> 1.2'
gem 'mini_magick'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'rails-i18n', '~> 5.1'
gem 'sass-rails'
gem 'simple_command'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'letter_opener'
  gem 'rb-readline'

  gem 'capistrano', '~> 3.11'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano3-puma', github: 'seuros/capistrano-puma'
end

group :test do
  gem 'database_cleaner', '~> 1.6', '>= 1.6.2'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'faker', '~> 1.8', '>= 1.8.7'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
end

group :development do
  gem 'annotate'
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
end
