# frozen_string_literal: true

ActiveAdmin.register Event do
  menu priority: 4
  includes :orders

  actions :index, :show, :edit, :update, :delete

  config.sort_order = 'starts_at_desc'

  scope :all, default: true
  scope('Текущие', &:future)
  scope('Прошедшие') { |scope| scope.where('events.ends_at < ?', Date.today) }

  index do
    selectable_column
    id_column
    column :name
    column(:dates) do |e|
      "#{l e.starts_at, format: :long if e.starts_at}" \
      "#{'—' if e.ends_at}" \
      "#{l e.ends_at, format: :long if e.ends_at}"
    end
    column(:tickets_sold) { |e| Ticket.where(order: e.orders.not_free).size }
    column(:summ) { |e| number_to_currency(e.orders.paid.sum { |o| o.payment.dig('amount') }, unit: '₽').gsub(' ', '&nbsp').html_safe }
    column('Посмотреть список покупателей') { |e| link_to 'Посмотреть список покупателей', admin_users_path(q: { event_id_in: e.id }, order: :id_desc) }
    column('Посмотреть ожидающих модерацию') { |e| link_to 'Посмотреть ожидающих модерацию', admin_users_path(q: { event_id_in: e.id }, order: :id_desc, scope: :ozhidanie) }
    actions do |event|
      link_to('Заказы.CSV', orders_csv_admin_event_path(event, format: :csv))
    end
  end

  config.filters = false

  member_action :orders_csv do
    send_data resource.orders.to_csv, filename: "users-#{Date.today}.csv"
  end

  sidebar I18n.t('activerecord.attributes.user.photo'), only: :show do
    attributes_table_for event do
      row(' ') do |e|
        link_to(image_tag(e.poster_image.variant(resize: '300x300>', auto_orient: true)), e.poster_image) if e.poster_image.attached?
      end
      row :description_short
      row :description_html
      row(:fb_link) { |e| link_to e.fb_link, e.fb_link }
      row(:map_link) { |e| link_to(e.full_address, e.map_link, target: '_blank') if e.map_link }
    end
  end

  show do
    attributes_table title: I18n.t('activerecord.models.event.one') do
      row :name
      row(:timepad_description) { |e| e.timepad_description.html_safe }
      row(:performances) do |e|
        e.performances.each do |p|
          div b p.name
          div p.description
          br
        end
        nil
      end
      row :phone
      row :conditions
      row(:line_ups) do |e|
        e.line_ups.each do |l|
          div b l.name
          div l.timing
          div l.description
          br
        end
        nil
      end
    end

    panel I18n.t('activerecord.models.ticket_type.other') do
      table_for event.ticket_types do
        column :id
        column :is_active
        column :status
        column :name
        column :price
        column('Доступно') { |tt| "#{tt.remaining} / #{tt.limit}" }
        column 'Даты продажи' do |tt|
          text_node "С&nbsp;#{l tt.sale_starts_at, format: :long}".html_safe if tt.sale_starts_at
          text_node '&nbsp;'.html_safe
          text_node "До&nbsp;#{l tt.sale_ends_at, format: :long}".html_safe if tt.sale_ends_at
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys)
      f.input :name
      f.input :starts_at, as: :date_time_picker
      f.input :ends_at, as: :date_time_picker
      f.input :description_short
      f.input :description_html
      f.input :coordinates
      f.input :fb_link
      f.input :conditions
      f.input :access_status, collection: enum_options_for_select(Event, :access_status)
      f.input :poster_image, as: :file, image_preview: true, input_html: { direct_upload: true }
    end
    f.inputs I18n.t('activerecord.models.performance.other') do
      f.has_many :performances,
                 new_record: 'Добавить',
                 heading: nil,
                 allow_destroy: true do |t|
        t.input :name
        t.input :description, input_html: { rows: 4 }
      end
    end
    f.inputs I18n.t('activerecord.models.line_up.other') do
      f.has_many :line_ups,
                 new_record: 'Добавить',
                 heading: nil,
                 allow_destroy: true do |t|
        t.input :name
        t.input :timing
        t.input :description, input_html: { rows: 4 }
      end
    end
    f.actions
  end
end
