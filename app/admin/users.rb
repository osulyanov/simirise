# frozen_string_literal: true

ActiveAdmin.register User do
  menu priority: 1

  index do
    selectable_column
    id_column
    column :name
    column :fb_link
    column :phone
    column :email
    my_tag_column :state, interactive: true
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
      f.input :state, collection: enum_options_for_select(User, :state)
      f.input :tags, as: :tags, collection: User.tags
      f.input :comment
      f.input :photo, as: :file, image_preview: true, input_html: { direct_upload: true }
    end
    f.actions
  end

  controller do
    def create
      params[:user].delete('virtual_tags_attr')
      super
    end

    def update
      params[:user].delete('virtual_tags_attr')
      super
    end
  end
end
