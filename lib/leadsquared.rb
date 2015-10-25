require 'leadsquared/config'
require 'leadsquared/client'
require 'leadsquared/lead_management'
require 'leadsquared/invalid_request_error'
require 'leadsquared/engine' if defined?(Rails)

module Leadsquared
  VERSION = File.read(File.expand_path('../../VERSION', __FILE__)).strip.freeze

  def self.logger
    config.logger
  end
end
