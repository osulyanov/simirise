# frozen_string_literal: true

class CreateTicketTypesTickets < ActiveRecord::Migration[5.2]
  def change
    create_join_table :ticket_types, :tickets
  end
end
