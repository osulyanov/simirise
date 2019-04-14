# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(admin)
    can :read, ActiveAdmin::Page, name: 'Dashboard', namespace_name: 'admin'
    admin.access.each do |model|
      next unless model.present?

      can :manage, model.classify.constantize
    end
  end
end
