# frozen_string_literal: true

ActiveAdmin.register AdminUser do
  menu priority: 8

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :created_at

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys.select { |s| (s =~ /[\.]+/) == nil })
      f.input :name
      f.input :email
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
