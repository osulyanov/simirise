#!/usr/bin/env puma
# frozen_string_literal: true

environment 'production'
port ENV.fetch('PORT') { 3000 }
tag ''

stdout_redirect '/app/log/puma_access.log', '/app/log/puma_error.log', true

threads 0, 16

workers 0

restart_command 'bundle exec puma'

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = ''
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
