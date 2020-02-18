# frozen_string_literal: true

require 'test_helper'

class Tracer::HelpersTest < TracerTests::TestCase
  class Wahoo
    extend Tracer::Helpers

    trace_methods :wahoo

    def wahoo; end
  end

  def test_that_it_wraps_methods_in_a_tracer
    adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = Tracer::Config.new
    config.adapter = adapter

    Tracer.stub(:config, config) do
      Wahoo.new.wahoo

      assert_equal ['wahoo'], Wahoo.traces

      callers = Wahoo.traced_callers
      assert_equal 1, callers.length
      assert_match %r{tracer/test/tracer/helpers_test\.rb:\d+$}, callers['wahoo'].first
    end
  end

  def test_that_it_requires_some_methods_to_trace
    assert_raises Tracer::UnspecifiedMethods do
      Class.new do
        extend Tracer::Helpers

        trace_method
      end
    rescue => ex
      assert_equal 'You must give at least one method to trace', ex.message
      raise
    end
  end
end
