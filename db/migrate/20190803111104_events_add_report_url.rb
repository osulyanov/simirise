# frozen_string_literal: true

class EventsAddReportUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :report_url, :string
  end
end
