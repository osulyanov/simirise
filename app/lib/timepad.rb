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
    @options[:query][:sort] = '-starts'
    @options[:query][:limit] = 100
    @options[:query][:starts_at_min] = '2017-06-16T00:00:00+0300'
    @options[:query][:organization_ids] = Setting.first.organization_id
    @options[:query][:access_statuses] = %i[private draft link_only public].join ','
    @options[:query][:moderation_status] = %i[featured shown hidden not_moderated].join ','
    @result = self.class.get('/events', @options)
    self
  end

  def orders(event_id, query = {})
    @options[:query] = query
    @options[:query][:sort] = '+created_at'
    @options[:query][:limit] = 250
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
    @options[:body] = {
      'tickets' => [
        {
          'answers' => {},
          'ticket_type_id' => 2448641
        }
      ],
      'answers' => {
        'mail' => 'test1@sulyanov.com',
        'surname' => 'Sulyanov',
        'name' => 'Oleg',
        'phone' => '89099079070',
        'question4122301' => '123'
      },
      'promocodes' => [],
      'subscribed_to_newsletter' => true
    }.to_json
    @result = self.class.post("/events/#{event_id}/orders", @options)
    self
  end
  # {
  #   "id": 23026193,
  #   "created_at": "2019-06-13T21:49:08+0300",
  #   "status": {
  #     "name": "pending",
  #     "title": "рассматривается"
  #   },
  #   "mail": "test1@sulyanov.com",
  #   "payment": {
  #     "amount": 3500,
  #     "payment_link": "https://application.timepad.ru/partners/paymentStart/36103084/"
  #   },
  #   "tickets": [
  #     {
  #       "id": 29122549,
  #       "number": "29122549:26879437",
  #       "price_nominal": "3500",
  #       "answers": {
  #         "mail": "test1@sulyanov.com",
  #         "surname": "Sulyanov",
  #         "name": "Oleg",
  #         "phone": "89099079070",
  #         "question4122301": "123",
  #         "question4147793": "-"
  #       },
  #       "ticket_type": {
  #         "id": 2448641,
  #         "name": "Входной билет",
  #         "description": "* Цена билета действительна на день оплаты. По мере приближения к мероприятию стоимость билета увеличивается.",
  #         "buy_amount_min": 1,
  #         "buy_amount_max": 2,
  #         "price": 3500,
  #         "is_promocode_locked": false,
  #         "remaining": 1822,
  #         "sale_ends_at": "2019-07-20T17:00:00+0300",
  #         "is_active": true,
  #         "ad_partner_profit": 0,
  #         "send_personal_links": true,
  #         "status": "ok"
  #       },
  #       "attendance": {},
  #       "place": {},
  #       "codes": {
  #         "ean13": "1000268794375",
  #         "ean8": "26879437",
  #         "printed_code": "1000268794375"
  #       },
  #       "personal_link": false
  #     }
  #   ],
  #   "promocodes": [],
  #   "event": {
  #     "id": 966448
  #   },
  #   "referrer": {
  #     "campaign": "Переходы с сайтов",
  #     "medium": "Переходы с сайтов",
  #     "source": "api.timepad.ru"
  #   },
  #   "subscribed_to_newsletter": false,
  #   "meta": {
  #     "request_snapshot": {
  #       "api_key": "2c3dfa87ec85c3d298fb6c349fb500a2ebf41ca8 65132"
  #     },
  #     "policy_metadata_snapshot": [],
  #     "stat_metadata": {
  #       "event_id": "966448",
  #       "org_id": "65132",
  #       "from": "TimepadApi"
  #     },
  #     "used_promocodes": [],
  #     "subscribe": false,
  #     "subscribe_digest": false,
  #     "referringMAId": 0,
  #     "culture": "ru",
  #     "second_phase_done": "2019-06-13 21:49:08"
  #   },
  #   "_links": {
  #     "tp:pay": [
  #       {
  #         "name": "yandexmoney_visa",
  #         "title": "Банковская карта",
  #         "href": "https://application.timepad.ru/partners/paymentStart/36103084/?method=yandexmoney_visa&go=gogogo&from=widget"
  #       },
  #       {
  #         "name": "yandexmoney",
  #         "title": "Яндекс деньги",
  #         "href": "https://application.timepad.ru/partners/paymentStart/36103084/?method=yandexmoney&go=gogogo&from=widget"
  #       },
  #       {
  #         "name": "webmoney",
  #         "title": "Webmoney",
  #         "href": "https://application.timepad.ru/partners/paymentStart/36103084/?method=webmoney&go=gogogo&from=widget"
  #       },
  #       {
  #         "name": "qiwi",
  #         "title": "QIWI Кошелёк",
  #         "href": "https://application.timepad.ru/partners/paymentStart/36103084/?method=qiwi&go=gogogo&from=widget"
  #       },
  #       {
  #         "name": "yandexmoney_terminals",
  #         "title": "Через терминал",
  #         "href": "https://application.timepad.ru/partners/paymentStart/36103084/?method=yandexmoney_terminals&go=gogogo&from=widget"
  #       },
  #       {
  #         "name": "yandexmoney_credit",
  #         "title": "Купить в кредит",
  #         "href": "https://application.timepad.ru/partners/paymentStart/36103084/?method=yandexmoney_credit&go=gogogo&from=widget"
  #       }
  #     ],
  #     "curies": {
  #       "name": "tp",
  #       "href": "http://dev.timepad.ru/api/hal#{rel}",
  #       "templated": true
  #     }
  #   }
  # }

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
