# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.date :birth_date
      t.string :fb_link
      t.string :phone
      t.integer :state, null: false, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
