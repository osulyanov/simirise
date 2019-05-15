# frozen_string_literal: true

class Timepad
  include HTTParty
  logger ::Logger.new('log/httparty.log'), :debug, :curl
  base_uri 'https://api.timepad.ru/v1'

  attr_reader :result

  def initialize
    @options = default_options
    @result = nil
  end

  def events
    # @options[:fields] = %i[location].join ','
    # @options[:token] = Setting.first.timepad_token
    # @options[:sip] = 0
    # @options[:limit] = 100
    # @options[:sort] = '+created_at'
    @options['organization_ids'] = Setting.first.organization_id
    # @options[:access_statuses] = %i[private draft link_only public].join ','
    @result = self.class.get('/events', @options)
    self
  end

  def success?
    @result.code == 200
  end

  def error_message
    @result.parsed_response['meta']['message']
  end

  def default_options
    {}
  end
end
