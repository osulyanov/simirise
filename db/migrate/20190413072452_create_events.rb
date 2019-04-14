class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :timepad_id
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :description_short
      t.text :description_html
      t.string :coordinates
      t.string :fb_link
      t.text :conditions
      t.integer :access_status, null: false, default: 0

      t.timestamps
    end
  end
end
