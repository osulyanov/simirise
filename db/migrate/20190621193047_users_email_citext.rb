# frozen_string_literal: true

class UsersEmailCitext < ActiveRecord::Migration[5.2]
  def up
    enable_extension('citext')
    change_column :users, :email, :citext
    add_index :users, :email
  end

  def down
    change_column :users, :email, :string
    remove_index :users, :email
  end
end
