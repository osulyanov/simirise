# frozen_string_literal: true

ActiveAdmin.register AdminUser do
  menu priority: 8

  index do
    selectable_column
    id_column
    column :name
    column(:age) { |u| age(u.birth_date) }
    column(:fb_link) { |u| link_to(u.fb_link, u.fb_link) if u.fb_link.present? }
    column :phone
    column :email
    column :position
    actions
  end

  config.filters = false

  sidebar I18n.t('activerecord.attributes.admin_user.photo'), only: :show do
    attributes_table_for admin_user do
      row(' ') do |e|
        link_to(image_tag(e.photo.variant(resize: '300x300>', auto_orient: true)), e.photo) if e.photo.attached?
      end
    end
  end

  show do
    attributes_table title: I18n.t('activerecord.models.admin_user.one') do
      row :name
      row(:age) { |u| age(u.birth_date) }
      row :phone
      row(:fb_link) { |u| link_to(u.fb_link, u.fb_link) if u.fb_link.present?}
      row :email
      row :position
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys)
      f.input :name
      f.input :email
      f.input :phone
      f.input :birth_date
      f.input :fb_link
      f.input :position
      f.input :photo, as: :file, image_preview: true, input_html: { direct_upload: true }
      f.inputs I18n.t('activerecord.attributes.admin_user.access') do
        f.input :access, as: :check_boxes, collection: const_options_for_select(AdminUser, 'ACCESS_LEVELS')
      end
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete('password')
        params[:admin_user].delete('password_confirmation')
      end
      super
    end
  end
end
