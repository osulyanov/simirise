# frozen_string_literal: true

class UserAddSmsAttrs < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sms_code, :string
    add_column :users, :smsed_at, :datetime
  end
end
