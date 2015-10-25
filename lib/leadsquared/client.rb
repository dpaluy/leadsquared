require 'faraday'
require 'json'

module Leadsquared
  class Client
    ENDPOINT = 'https://api.leadsquared.com'.freeze
    HEADERS = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}.freeze

    attr_reader :key, :secret, :endpoint

    def initialize(key = nil, secret = nil, endpoint = nil)
      @key      = key       || Leadsquared.config.key
      @secret   = secret    || Leadsquared.config.secret
      @endpoint = endpoint  || Leadsquared.config.endpoint || ENDPOINT
      raise ArgumentError.new("Missing key or secret") unless @secret and @key
    end

    def post(url, params = {}, body = nil)
      conn = Faraday.new(url: @endpoint)
      merged_params = {accessKey: @key, secretKey: @secret}.merge(params)
      response = conn.post(url) do |req|
        req.headers = HEADERS
        req.params  = merged_params
        req.body    = body if body
      end

      response
    end

    def get(url, params = {})
      conn = Faraday.new(url: @endpoint)
      merged_params = {accessKey: @key, secretKey: @secret}.merge(params)
      response = conn.get(url) do |req|
        req.headers = HEADERS
        req.params  = merged_params
      end

      response
    end

  end
end
