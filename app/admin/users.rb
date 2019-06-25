# frozen_string_literal: true

ActiveAdmin.register User do
  menu priority: 1

  scope :all, default: true
  User.states.keys.each do |state|
    scope(I18n.t("activerecord.attributes.user.states.#{state}")) { |scope| scope.where(state: state) }
  end

  index do
    selectable_column
    id_column
    column :name
    column(:fb_link) { |u| link_to(u.fb_link, u.fb_link) if u.fb_link.present? }
    column :phone
    column :email
    my_tag_column :state, interactive: true
    column(:tags) { |u| u.tags.map(&:name).join(', ') }
    column('Количество билетов') { |u| u.tickets.size }
    actions
  end

  filter :name
  filter :fb_link
  filter :phone
  filter :email
  filter :state
  filter :tags
  filter :comment
  filter :event_id_in, as: :select, collection: Event.all

  sidebar I18n.t('activerecord.attributes.user.photo'), only: :show do
    attributes_table_for user do
      row(' ') do |e|
        link_to(image_tag(e.photo.variant(resize: '300x300>', auto_orient: true)), e.photo) if e.photo.attached?
      end
    end
  end

  show do
    attributes_table title: I18n.t('activerecord.models.user.one') do
      row :name
      row(:age) { |u| age(u.birth_date) }
      row :phone
      my_tag_row :state
      row(:fb_link) { |u| link_to(u.fb_link, u.fb_link) if u.fb_link.present? }
      row(:tags) { |u| u.tags.map(&:name).join ', ' }
      row :email
      row :answers
    end
    # TODO: Tickets
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys)
      f.input :photo, as: :file, image_preview: true, input_html: { direct_upload: true }
      f.input :name
      f.input :email, as: :string
      f.input :phone
      f.input :birth_date, as: :date_time_picker, picker_options: { timepicker: false,
                                                                    min_date: Date.today - 100.years,
                                                                    max_date: Date.today - 16.years,
                                                                    format: 'Y-m-d' }
      f.input :fb_link
      f.input :state, collection: enum_options_for_select(User, :state)
      f.input :tag_ids, as: :tags, collection: Tag.all
      f.input :comment
    end
    f.actions
  end

  controller do
    def create
      params[:user].delete('virtual_tag_ids_attr')
      super
    end

    def update
      params[:user].delete('virtual_tag_ids_attr')
      super
    end
  end
end
