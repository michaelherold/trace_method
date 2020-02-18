# frozen_string_literal: true

require 'test_helper'

class Tracer::ModuleTest < TracerTests::TestCase
  class Foo
    prepend Tracer::Module.new(:foo, :bar)

    def foo; end

    # rubocop:disable Naming/UncommunicativeMethodParamName
    def bar(a, b = 'b', *args, c:, d: 'd', **kwargs)
      [a, b, *args, c, d, kwargs, block_given? ? yield : nil].compact
    end
    # rubocop:enable Naming/UncommunicativeMethodParamName
  end

  def test_that_it_wraps_methods_in_a_tracer
    adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = Tracer::Config.new
    config.adapter = adapter

    Tracer.stub(:config, config) { Foo.new.foo }

    assert_equal ['foo'], adapter.fetch_traces(Foo.name)

    callers = adapter.fetch_callers(Foo.name, 'foo')
    assert_equal 1, callers.length
    assert_match %r{test/tracer/module_test\.rb:\d+$}, callers.first
  end

  def test_that_is_properly_delegates_arguments
    adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = Tracer::Config.new
    config.adapter = adapter

    Tracer.stub(:config, config) do
      assert_equal [1, 2, 3, 4, 5, { e: 6 }, 7], Foo.new.bar(1, 2, 3, c: 4, d: 5, e: 6) { 7 }
    end
  end

  def test_inspect
    mod = Tracer::Module.new(:foo, :bar, :baz)

    assert_equal 'Tracer(foo, bar, baz)', mod.inspect
  end

  def test_caller_extraction_with_an_app_root
    adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = Tracer::Config.new
    config.adapter = adapter

    Tracer.method(:stub).source_location.then do |mock_file, _|
      config.app_root = File.dirname(mock_file)
    end

    Tracer.stub(:config, config) { Foo.new.foo }

    assert_equal ['foo'], adapter.fetch_traces(Foo.name)

    callers = adapter.fetch_callers(Foo.name, 'foo')
    assert_equal 1, callers.length
    assert_match(%r{^/mock\.rb:\d+$}, callers.first)
  end

  def test_caller_extraction_with_an_app_root_and_ignores
    adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = Tracer::Config.new
    config.adapter = adapter

    Tracer.method(:stub).source_location.then do |mock_file, _|
      config.app_root = File.dirname(mock_file)
      config.ignored = File.basename(mock_file)
    end

    Tracer.stub(:config, config) { Foo.new.foo }

    assert_equal ['foo'], adapter.fetch_traces(Foo.name)

    callers = adapter.fetch_callers(Foo.name, 'foo')
    assert_equal 1, callers.length
    assert_match(/test\.rb:\d+$/, callers.first)
  end
end
