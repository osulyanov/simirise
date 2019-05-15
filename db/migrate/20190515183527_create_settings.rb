class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.jsonb :data

      t.timestamps
    end
  end
end
