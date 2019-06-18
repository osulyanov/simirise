class EventsAddTimepadDescription < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :timepad_description, :text
  end
end
