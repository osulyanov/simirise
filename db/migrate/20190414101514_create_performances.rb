# frozen_string_literal: true

class CreatePerformances < ActiveRecord::Migration[5.2]
  def change
    create_table :performances do |t|
      t.references :event, index: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
