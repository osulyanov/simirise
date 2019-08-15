# frozen_string_literal: true

class TicketsAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :user_id, :integer
    add_index :tickets, :user_id
  end
end
