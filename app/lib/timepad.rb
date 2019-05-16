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

  def events(query = {})
    @options[:query] = query
    @options[:query][:fields] = %i[ends_at location ticket_types questions access_status registration_data].join ','
    @options[:query][:sort] = '+created_at'
    @options[:query][:organization_ids] = Setting.first.organization_id
    @options[:query][:access_statuses] = %i[private draft link_only public].join ','
    @options[:query][:moderation_status] = %i[featured shown hidden not_moderated].join ','
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
    { headers: { Authorization: "Bearer #{Setting.first.timepad_token}" } }
  end
end
