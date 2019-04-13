# frozen_string_literal: true

ActiveAdmin.register AdminUser do
  menu priority: 8

  index do
    selectable_column
    id_column
    column :name
    column(:age) { |u| age(u.birth_date) }
    column :fb_link
    column :phone
    column :email
    column :position
    actions
  end

  config.filters = false

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
