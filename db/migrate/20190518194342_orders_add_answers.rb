class OrdersAddAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :answers, :jsonb
  end
end
