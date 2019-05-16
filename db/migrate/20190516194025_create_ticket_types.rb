class CreateTicketTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_types do |t|
      t.integer timepad_id,
t. :name"=>"Single Ticket",
t. :description"=>"Early bird",
t. :buy_amount_min"=>1,
t. :buy_amount_max"=>30,
t. :price"=>2220,
t. :is_promocode_locked"=>false,
t. :remaining"=>1806,
t. :sale_ends_at"=>"2019-04-03T23:59:00+0300",
t. :sale_starts_at"=>"2019-04-03T00:00:00+0300",
t. :public_key"=>"-----BEGIN PUBLIC KEY-----\r\nMDwwDQYJKoZIhvcNAQEBBQADKwAwKAIhAJPtKGjKjX0RLc2mGqLiF+MU0HJ99aie\r\nZFZn+iBhEgNnAgMBAAE=\r\n-----END PUBLIC KEY-----",
t. :is_active"=>true,
t. :ad_partner_profit"=>0,
t. :send_personal_links"=>true,
t. :sold"=>0,
t. :attended"=>0,
t. :limit"=>2000,
t. :status"=>"late"

      t.timestamps
    end
  end
end
