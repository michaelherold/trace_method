# frozen_string_literal: true

require 'monitor'

require 'tracer/core_ext/module'

require 'tracer/adapters'
require 'tracer/config'
require 'tracer/helpers'
require 'tracer/module'
require 'tracer/version'

module Tracer
  class Error < StandardError; end
  class UnspecifiedMethods < Error; end

  def self.configure
    mutex.synchronize do
      yield config
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.mutex
    @mutex ||= Monitor.new
  end

  def self.traced_modules
    config.adapter.fetch_traced_modules
  end
end
