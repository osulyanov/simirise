# frozen_string_literal: true

class TicketAddEticketLink < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :eticket_link, :string
  end
end
