# frozen_string_literal: true

require 'monitor'

require_relative 'trace_method/core_ext/module'

require_relative 'trace_method/adapters'
require_relative 'trace_method/config'
require_relative 'trace_method/helpers'
require_relative 'trace_method/module'
require_relative 'trace_method/trace'
require_relative 'trace_method/version'

module TraceMethod
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

  def self.modules_with_traces
    config.adapter.modules
  end
end
