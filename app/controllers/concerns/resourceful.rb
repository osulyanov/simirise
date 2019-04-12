# frozen_string_literal: true

module Resourceful
  extend ActiveSupport::Concern

  included do
    helper_method :set

    attr_writer :resource_instance_name, :resource_collection_name, :resource_class_name, :resource_class
  end

  def index
    render json: collection, each_serializer: serializer
  end

  def set
    render json: collection, each_serializer: serializer
  end

  def show
    render json: resource, serializer: serializer
  end

  def create
    build_resource

    if resource.save
      render json: resource, status: :created, serializer: serializer
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  def update
    if resource.update(permitted_params)
      render json: resource, serializer: serializer
    else
      render json: { errors: resource.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: resource.destroy, serializer: serializer
  end

  class_methods do
    def resource_instance_path
      name.sub(/Controller$/, '')
    end

    def resource_instance_name
      resource_instance_path.underscore.singularize.split('/').last.to_sym
    end

    def resource_collection_name
      resource_instance_name.to_s.pluralize.to_sym
    end

    def resource_class
      resource_instance_name.to_s.classify.constantize
    end

    def resource_class_name
      resource_class.name
    end
  end

  private

  def resource_class
    @resource_class ||= self.class.resource_class
  end

  def resource_instance_path
    @resource_instance_path ||= self.class.resource_instance_path
  end

  def resource_instance_name
    @resource_instance_name ||= self.class.resource_instance_name
  end

  def resource_class_name
    @resource_class_name ||= self.class.resource_class.name
  end

  def resource_collection_name
    @resource_collection_name ||= self.class.resource_collection_name
  end

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find(params[:id]))
  end

  def collection
    get_collection_ivar || set_collection_ivar(
      if set_params
        end_of_association_chain.find(set_params)
      else
        end_of_association_chain.all
      end
    )
  end

  def build_resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.new(permitted_params))
  end

  def parents
    []
  end

  def parent
    parent = parents.select { |parent| params["#{parent}_id".to_sym] }.first
    parent.to_s.classify.constantize.find(params["#{parent}_id".to_sym]) if parent
  end

  def parent?
    !!parent
  end

  def end_of_association_chain
    (parent? ? parent.send(resource_collection_name) : resource_class)
  end

  def set_params
    return unless params[:ids].present?

    ids = params[:ids].split(/\.|\,/)
    ids if ids.any? && ids.all?(&:numeric?)
  end

  def permitted_params
    {}
  end

  def get_resource_ivar
    instance_variable_get("@#{safe_symbol resource_instance_name}")
  end

  def set_resource_ivar(resource)
    instance_variable_set("@#{safe_symbol resource_instance_name}", resource)
  end

  def get_collection_ivar
    instance_variable_get("@#{safe_symbol resource_collection_name}")
  end

  def set_collection_ivar(collection)
    instance_variable_set("@#{safe_symbol resource_collection_name}", collection)
  end

  def serializer
    "#{resource_instance_path}Serializer".classify.constantize
    # rescue StandardError
    #   nil
  end

  def safe_symbol(name)
    name.to_s.gsub(/[^0-9A-Za-z]/, '').to_sym
  end
end
