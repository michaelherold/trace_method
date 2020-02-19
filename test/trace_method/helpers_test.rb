# frozen_string_literal: true

require 'test_helper'

class TraceMethod::HelpersTest < TraceMethodTests::TestCase
  class Wahoo
    extend TraceMethod::Helpers

    trace_methods :wahoo

    def wahoo; end
  end

  def test_that_it_wraps_methods_in_a_trace_method
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = TraceMethod::Config.new
    config.adapter = adapter

    TraceMethod.stub(:config, config) do
      Wahoo.new.wahoo

      assert_equal ['wahoo'], Wahoo.traces

      callers = Wahoo.traced_callers
      assert_equal 1, callers.length
      assert_match %r{test/trace_method/helpers_test\.rb:\d+$}, callers['wahoo'].first
    end
  end

  def test_that_it_requires_some_methods_to_trace
    assert_raises_with_message TraceMethod::UnspecifiedMethods, message: 'You must give at least one method to trace' do
      Class.new do
        extend TraceMethod::Helpers

        trace_method
      end
    end
  end

  def test_that_it_extends_a_preexisting_module
    preexisting = Class.new do
      extend TraceMethod::Helpers

      trace_methods :cool
      trace_methods :no_doubt

      def cool; end

      def no_doubt; end
    end

    modules = preexisting.ancestors.select(&:__trace_method__?)

    assert_equal 1, modules.length

    mod = modules.first
    assert_equal %i[cool no_doubt], mod.instance_methods.sort
    assert_equal 'TraceMethod(cool, no_doubt)', mod.inspect
  end
end
