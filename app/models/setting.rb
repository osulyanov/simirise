# frozen_string_literal: true


class Setting < ApplicationRecord
  store_accessor :data, :timepad_token, :organization_id
end

# == Schema Information
#
# Table name: settings
#
#  id         :bigint(8)        not null, primary key
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
