class UsersAddAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :answers, :jsonb
  end
end
