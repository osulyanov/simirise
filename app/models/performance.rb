# frozen_string_literal: true

class Performance < ApplicationRecord
  belongs_to :event
end

# == Schema Information
#
# Table name: performances
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint(8)
#
# Indexes
#
#  index_performances_on_event_id  (event_id)
#
