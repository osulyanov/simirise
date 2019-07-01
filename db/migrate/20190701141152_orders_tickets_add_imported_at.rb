# frozen_string_literal: true

class OrdersTicketsAddImportedAt < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :imported_at, :datetime
    add_column :tickets, :imported_at, :datetime
    add_index :orders, :imported_at
    add_index :tickets, :imported_at
  end
end
