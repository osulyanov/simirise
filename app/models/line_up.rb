# frozen_string_literal: true

class LineUp < ApplicationRecord
  belongs_to :event
end

# == Schema Information
#
# Table name: line_ups
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  name        :string
#  timing      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint(8)
#
# Indexes
#
#  index_line_ups_on_event_id  (event_id)
#
