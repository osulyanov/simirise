# frozen_string_literal: true

class AdminAdminAccess < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :access, :text, array: true, default: []
  end
end
