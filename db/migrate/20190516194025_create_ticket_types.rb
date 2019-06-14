# frozen_string_literal: true

class CreateTicketTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_types do |t|
      t.integer :timepad_id
      t.references :event, index: true
      t.string :name
      t.string :description
      t.integer :buy_amount_min
      t.integer :buy_amount_max
      t.integer :price
      t.boolean :is_promocode_locked
      t.integer :remaining
      t.datetime :sale_ends_at
      t.datetime :sale_starts_at
      t.string :public_key
      t.boolean :is_active
      t.integer :ad_partner_profit
      t.boolean :send_personal_links
      t.integer :sold
      t.integer :attended
      t.integer :limit
      t.string :status
      t.timestamps
    end
  end
end
