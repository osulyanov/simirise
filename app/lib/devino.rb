# frozen_string_literal: true

class Devino
  include HTTParty
  logger ::Logger.new('log/httparty.log'), :debug, :curl
  base_uri 'https://integrationapi.net/rest'

  attr_reader :result

  def initialize
    @options = {}
    @result = nil
  end

  def token_request
    @options[:query] = {
      login: Rails.application.credentials.devino_login,
      password: Rails.application.credentials.devino_password
    }
    req = self.class.get('/user/sessionid', @options)
    raise "Auth Error: #{req.parsed_response['meta']['message']}" unless req.code == 200

    req
  end

  def balance
    @options[:query] = {
      SessionId: token
    }
    self.class.get('/User/Balance', @options).parsed_response
  end

  def sms(to, text)
    Rails.logger.info "> Devino balance #{balance}"
    @options[:query] = {
      SessionId: token,
      DestinationAddress: to,
      SourceAddress: Rails.application.credentials.devino_from,
      Data: text
    }
    self.class.post('/Sms/Send', @options)
    self
  end

  def token
    @token ||= request_a_token
  end

  def success?
    @result.code == 200
  end

  def error_message
    @result.parsed_response['meta']['message']
  end

  private

  def request_a_token
    token_request.parsed_response
  end
end
