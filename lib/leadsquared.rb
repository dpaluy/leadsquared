require 'leadsquared/config'
require 'leadsquared/client'
require 'leadsquared/engine' if defined?(Rails)

module Leadsquared
  VERSION = File.read(File.expand_path('../../VERSION', __FILE__)).strip.freeze

  def self.logger
    config.logger
  end
end
