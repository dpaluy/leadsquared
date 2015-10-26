require 'leadsquared/config'
require 'leadsquared/client'
require 'leadsquared/api_connection'
require 'leadsquared/lead'
require 'leadsquared/activity'
require 'leadsquared/invalid_request_error'
require 'leadsquared/engine' if defined?(Rails)

module Leadsquared
  VERSION = File.read(File.expand_path('../../VERSION', __FILE__)).strip.freeze

  def self.logger
    config.logger
  end
end
