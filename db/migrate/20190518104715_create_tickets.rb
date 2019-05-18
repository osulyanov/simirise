class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :order, index: true
      t.references :ticket_type
      t.integer :timepad_id
      t.string :number
      t.integer :price_nominal
      t.jsonb :answers
      t.jsonb :attendance
      t.jsonb :place
      t.jsonb :codes

      t.timestamps
    end
  end
end
