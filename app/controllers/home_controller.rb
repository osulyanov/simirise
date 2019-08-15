# frozen_string_literal: true

class HomeController < ApplicationController
  def webhook
    render inline: params['hub.challenge']
  end
end
