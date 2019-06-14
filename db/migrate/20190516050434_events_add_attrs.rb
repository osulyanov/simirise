# frozen_string_literal: true

class EventsAddAttrs < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :location, :jsonb, null: false, default: {}
    add_column :events, :questions, :jsonb, null: false, default: []
    add_column :events, :moderation_status, :integer, null: false, default: 0
  end
end
