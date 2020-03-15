# frozen_string_literal: true

require 'test_helper'

class TraceMethodTest < TraceMethodTests::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::TraceMethod::VERSION
  end

  def test_that_it_can_be_configured
    TraceMethod.configure do |config|
      config.adapter = 'foo'
    end

    assert_equal 'foo', TraceMethod.config.adapter
  end

  def test_that_it_can_retrieve_modules_with_traces
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = TraceMethod::Config.new
    config.adapter = adapter

    sample = Class.new do
      extend TraceMethod::Helpers

      trace_method :testing

      def self.name
        'Sample'
      end

      def testing; end
    end

    TraceMethod.stub(:config, config) do
      sample.new.testing

      assert_equal ['Sample'], TraceMethod.modules_with_traces
    end
  end
end
