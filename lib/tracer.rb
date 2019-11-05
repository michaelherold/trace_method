require 'monitor'

require 'tracer/config'
require 'tracer/version'

module Tracer
  class Error < StandardError; end

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
end
