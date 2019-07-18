# frozen_string_literal: true

class UsersAddMessangerData < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :source, :string
    add_column :users, :fb_id, :string
    add_index :users, :fb_id
    add_column :users, :messages, :jsonb
  end
end
