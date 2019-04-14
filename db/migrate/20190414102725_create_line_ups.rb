class CreateLineUps < ActiveRecord::Migration[5.2]
  def change
    create_table :line_ups do |t|
      t.references :event, index: true
      t.string :name
      t.string :timing
      t.text :description

      t.timestamps
    end
  end
end
