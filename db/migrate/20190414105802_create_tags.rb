# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    create_join_table :tags, :users

    remove_column :users, :tags, :string
  end
end
