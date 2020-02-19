# frozen_string_literal: true

require 'test_helper'

class TracerTest < TracerTests::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Tracer::VERSION
  end

  def test_that_it_can_be_configured
    Tracer.configure do |config|
      config.adapter = 'foo'
    end

    assert_equal 'foo', Tracer.config.adapter
  end

  def test_that_it_can_retrieve_modules_with_traces
    adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = Tracer::Config.new
    config.adapter = adapter

    sample = Class.new do
      extend Tracer::Helpers

      trace_method :testing

      def self.name
        'Sample'
      end

      def testing; end
    end

    Tracer.stub(:config, config) do
      sample.new.testing

      assert_equal ['Sample'], Tracer.traced_modules
    end
  end
end
