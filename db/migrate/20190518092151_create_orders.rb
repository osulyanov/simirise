# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :event, index: true
      t.integer :timepad_id
      t.jsonb :status
      t.string :mail
      t.jsonb :payment
      t.string :promocodes, array: true, default: []
      t.jsonb :referrer
      t.jsonb :meta

      t.timestamps
    end
  end
end
