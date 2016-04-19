module ApiHelper
  include Rack::Test::Methods

  def self.included(base)
    if !@included_api_helper
      @included_api_helper = true
    end
  end

  def app
    Rails.application
  end

  %i(get post patch put delete).each do |m|
    define_method "api_#{m}" do |path, params={}, headers={}|
      base_url = "/api"
      url = File.join(base_url, path)
      public_send(m, url, params, headers)
    end
  end

  def response
    last_response
  end

  def json_resp
    @json_resp ||= JSON.parse(response.body)
  end

  def parse_json_date(date)
    date.to_json.gsub("\"", "").to_json.gsub("\"", "")
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :controller
end
