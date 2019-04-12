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
      # f.input :tag_ids, as: :tags, collection: Tag.all, display_name: :name
      f.input :comment
      f.input :photo, as: :file, image_preview: true, input_html: { direct_upload: true }
    end
    f.actions
  end
end
