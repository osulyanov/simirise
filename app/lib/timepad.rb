# frozen_string_literal: true

class Timepad
  include HTTParty
  logger ::Logger.new('log/httparty.log'), :debug, :curl
  base_uri 'https://api.timepad.ru/v1'

  attr_reader :result

  def initialize
    @options = default_options
    @result = nil
  end

  def events(query = {})
    @options[:query] = query
    @options[:query][:fields] = %i[ends_at location ticket_types questions access_status registration_data].join ','
    @options[:query][:sort] = '+created_at'
    @options[:query][:organization_ids] = Setting.first.organization_id
    @options[:query][:access_statuses] = %i[private draft link_only public].join ','
    @options[:query][:moderation_status] = %i[featured shown hidden not_moderated].join ','
    @result = self.class.get('/events', @options)
    self
  end

  def orders(event_id, query = {})
    @options[:query] = query
    @options[:query][:sort] = '+created_at'
    @result = self.class.get("/events/#{event_id}/orders", @options)
    self
  end

  # {
  # "id"=>22217672,
  # "created_at"=>"2019-05-02T20:28:17+0300",
  # "status"=>{"name"=>"paid", "title"=>"оплачено"},
  # "mail"=>"sosiska_38@rambler.ru",
  # "payment"=>{"amount"=>1200, "paid_at"=>"2019-05-02T20:29:14+0300", "payment_type"=>"yandexmoney_visa"},
  # "tickets"=>[
    # {"id"=>28015389,
    # "number"=>"28015389:27781456",
    # "price_nominal"=>"1200",
    # "answers"=>{"mail"=>"sosiska_38@rambler.ru", "surname"=>"Шустова", "name"=>"Марианна", "phone"=>"+7 (926) 934-49-59"},
    # "ticket_type"=>{"id"=>2467638, "name"=>"Single ticket (1st release)", "description"=>"* Цена билета действительна на день оплаты. По мере приближения к мероприятию стоимость билета увеличивается.", "buy_amount_min"=>1, "buy_amount_max"=>30, "price"=>1500, "is_promocode_locked"=>false, "remaining"=>91, "sale_ends_at"=>"2019-05-14T12:00:00+0300", "is_active"=>true, "ad_partner_profit"=>0, "send_personal_links"=>true, "status"=>"late"},
    # "attendance"=>{}, — тут starts_at и ends_at
    # "place"=>{}, — тут id и description
    # "codes"=>{"ean13"=>"1000277814569", "ean8"=>"27781456", "printed_code"=>"1000277814569"},
    # "personal_link"=>false}
  # ],
  # "promocodes"=>{},
  # "referrer"=>{"campaign"=>"Переходы с сайтов", "medium"=>"Переходы с сайтов", "source"=>"www.facebook.com"},
  # "subscribed_to_newsletter"=>false,
  # "meta"=>{
    # "request_snapshot"=>{
      # "res"=>{"2467638"=>"1"},
      # "user_forms"=>[{"mail"=>"sosiska_38@rambler.ru", "surname"=>"Шустова", "name"=>"Марианна", "phone"=>"+7 (926) 934-49-59"}],
      # "accepted_terms"=>"on",
      # "tickets"=>[{"re_id"=>"2467638"}],
      # "locale"=>"ru",
      # "ga_cid"=>"1418962617.1556818047",
      # "aux"=>{"use_ticket_remind"=>"1"},
      # "referer"=>"https://www.facebook.com/",
      # "stat_metadata"=>{"event_id"=>"971757", "org_id"=>"65132", "event_cats"=>"457", "reg_count"=>"1", "questions_count"=>"4", "max_price"=>"0", "from"=>"isInTimepad", "widget_mode"=>"default", "widget_id"=>"", "widget_consumer_url"=>"https://application.timepad.ru/event/971757/?fbclid=IwAR2d3Q1B1p4Vxfy-NKsHzHyOEN_czw4qTYDTvFLS0mNCLxyd-9mYmYXmJxg", "use_multireg"=>"true", "widget_use_multiank"=>"false"}
    # },
    # "policy_metadata_snapshot"=>{},
    # "stat_metadata"=>{
      # "event_id"=>"971757",
      # "org_id"=>"65132",
      # "event_cats"=>"457",
      # "reg_count"=>"1",
      # "questions_count"=>"4",
      # "max_price"=>"0",
      # "from"=>"isInTimepad",
      # "widget_mode"=>"default",
      # "widget_id"=>"",
      # "widget_consumer_url"=>"https://application.timepad.ru/event/971757/?fbclid=IwAR2d3Q1B1p4Vxfy-NKsHzHyOEN_czw4qTYDTvFLS0mNCLxyd-9mYmYXmJxg",
      # "use_multireg"=>"true",
      # "widget_use_multiank"=>"false",
      # "payment_method"=>"yandexmoney_visa",
      # "payment_operator"=>"Yandexmoney",
      # "payment_link"=>"https://money.yandex.ru/eshop.xml?shopId=18566&scid=9753&sum=1258.80&cps_email=sosiska_38%40rambler.ru&orderNumber=34964430&customerNumber=34964430&paymentType=AC"
    # },
    # "aux"=>{"use_ticket_remind"=>"1"},
    # "used_promocodes"=>{},
    # "gaCid"=>"1418962617.1556818047",
    # "subscribe"=>false,
    # "subscribe_digest"=>false,
    # "referringMAId"=>0,
    # "culture"=>"ru",
    # "second_phase_done"=>"2019-05-02 20:28:17",
    # "first_pay"=>true
  # },
  # "_links"=>{}
  # }

  def create_order(event_id, query = {})
    @options[:query] = query
    @result = self.class.post("/events/#{event_id}/orders", @options)
    self
  end

  def success?
    @result.code == 200
  end

  def error_message
    @result.parsed_response['meta']['message']
  end

  def default_options
    { headers: { Authorization: "Bearer #{Setting.first.timepad_token}" } }
  end
end
