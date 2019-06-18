# frozen_string_literal: true

ActiveAdmin.register Event do
  menu priority: 4

  actions :index, :show, :edit, :update, :delete

  config.sort_order = 'starts_at_desc'

  scope :all, default: true
  Event.access_statuses.keys.each do |status|
    scope(I18n.t("activerecord.attributes.event.access_statuses.#{status}")) { |scope| scope.where(access_status: status) }
  end

  index do
    selectable_column
    id_column
    column :name
    column(:dates) do |e|
      "#{l e.starts_at, format: :long if e.starts_at}" \
      "#{'—' if e.ends_at}" \
      "#{l e.ends_at, format: :long if e.ends_at}"
    end
    column(:tickets_sold) { |e| e.tickets.size }
    # column(:summ) { |_u| 0 } # TODO
    # column(:guests) { |_u| 'LINK' } # TODO
    actions
  end

  config.filters = false

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
          text_node "&nbsp;".html_safe
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
