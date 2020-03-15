# frozen_string_literal: true

require 'test_helper'

class TraceMethod::HelpersTest < TraceMethodTests::TestCase
  class Wahoo
    extend TraceMethod::Helpers

    trace_methods :wahoo

    def wahoo; end
  end

  class ExtendedSingleton
    extend TraceMethod::Helpers

    trace_singleton_method :zipadee

    def self.zipadee; end
  end

  def test_that_it_wraps_methods_in_a_trace_method
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = TraceMethod::Config.new
    config.adapter = adapter

    TraceMethod.stub(:config, config) do
      Wahoo.new.wahoo

      assert_equal ['wahoo'], Wahoo.traces
      assert_match %r{test/trace_method/helpers_test\.rb:\d+$}, Wahoo.callers_of(:wahoo).first

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

  def test_that_singleton_methods_are_traceable
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = TraceMethod::Config.new
    config.adapter = adapter

    TraceMethod.stub(:config, config) do
      ExtendedSingleton.zipadee

      assert_equal ['zipadee'], ExtendedSingleton.singleton_traces
      assert_match %r{test/trace_method/helpers_test\.rb:\d+$}, ExtendedSingleton.singleton_callers_of('zipadee').first

      callers = ExtendedSingleton.singleton_traced_callers
      assert_equal 1, callers.length
      assert_match %r{test/trace_method/helpers_test\.rb:\d+$}, callers['zipadee'].first
    end
  end

  def test_that_anonymous_singleton_methods_are_traceable
    anonymous = Class.new do
      extend TraceMethod::Helpers

      trace_singleton_method :vuvuzela

      def self.vuvuzela; end
    end

    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = TraceMethod::Config.new
    config.adapter = adapter

    TraceMethod.stub(:config, config) do
      anonymous.vuvuzela

      assert_equal ['vuvuzela'], anonymous.singleton_traces
      assert_match %r{test/trace_method/helpers_test\.rb:\d+$}, anonymous.singleton_callers_of('vuvuzela').first

      callers = anonymous.singleton_traced_callers
      assert_equal 1, callers.length
      assert_match %r{test/trace_method/helpers_test\.rb:\d+$}, callers['vuvuzela'].first
    end
  end

  def test_singleton_key_naming
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = TraceMethod::Config.new
    config.adapter = adapter

    TraceMethod.stub(:config, config) do
      ExtendedSingleton.zipadee

      assert_equal ['Class::TraceMethod::HelpersTest::ExtendedSingleton'], TraceMethod.modules_with_traces
    end
  end

  def test_anonymous_module_key_patterns
    anonymous = Class.new do
      extend TraceMethod::Helpers

      trace_singleton_method :no_colons

      def self.no_colons; end
    end

    anonymous2 = Class.new do
      extend TraceMethod::Helpers

      trace_singleton_method :no_colons

      def self.no_colons; end
    end

    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = TraceMethod::Config.new
    config.adapter = adapter

    TraceMethod.stub(:config, config) do
      anonymous.no_colons
      anonymous2.no_colons

      modules = TraceMethod.modules_with_traces
      assert_equal 2, modules.length
      refute(modules.any? { |name| name.include?(':') || name.include?('<') || name.include?('>') })
    end
  end
end
