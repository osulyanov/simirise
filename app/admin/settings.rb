# frozen_string_literal: true

ActiveAdmin.register Setting do
  menu priority: 30,
       url: proc { edit_admin_setting_path(Setting.first) }

  actions :edit, :update

  controller do
    def update
      update! do |format|
        format.html { redirect_to edit_admin_setting_path(resource.id) } if resource.valid?
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :timepad_token
      f.input :organization_id
    end
    f.actions do
      f.action :submit
    end
  end
end
