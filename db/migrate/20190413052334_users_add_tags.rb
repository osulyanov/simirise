class UsersAddTags < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tags, :string
  end
end
