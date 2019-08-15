# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  def access_denied(exception)
    redirect_to admin_dashboard_path, alert: exception.message
  end
end
