# app/services/gpt_service.rb
require 'faraday'
require 'json'

class ConversionService
  BASE_URL = 'https://v6.exchangerate-api.com'

  def initialize(api_key = nil)
    @api_key = api_key || ENV['EXCHANGE_RATE_KEY']
  end

  def pair_conversion(base_currency, target_currency, amount_cents)
    response = connection.get("/v6/#{@api_key}/pair/#{base_currency}/#{target_currency}/#{amount_cents}").to_json
    body = JSON.parse(response)["body"]
    JSON.parse(body)
  end

  private

  def connection
    url = BASE_URL
    Faraday.new(url: url) do |conn|
      conn.headers['Content-Type'] = 'application/json'
      conn.adapter Faraday.default_adapter
    end
  end
end
