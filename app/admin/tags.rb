# frozen_string_literal: true

ActiveAdmin.register Tag do
  menu priority: 2

  index do
    selectable_column
    id_column
    column :name
    column :description
    column(:users) do |t|
      link_to t.users.count, admin_users_path(q: { tags_id_eq: t.id })
    end
    actions
  end

  config.filters = false

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys)
      f.input :name
      f.input :description
    end
    f.actions
  end
end
