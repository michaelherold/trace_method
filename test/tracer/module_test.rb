require 'test_helper'

class Tracer::ModuleTest < Minitest::Test
  class Foo
    prepend Tracer::Module.new(:foo)

    def foo; end
  end

  def test_that_it_wraps_methods_in_a_tracer
    adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    config = Tracer::Config.new
    config.adapter = adapter

    Tracer.stub(:config, config) { Foo.new.foo }

    assert_equal ['foo'], adapter.fetch_traces(Foo.name)

    callers = adapter.fetch_callers(Foo.name, 'foo')
    assert_equal 1, callers.length
    assert_match %r{tracer/test/tracer/module_test\.rb:15$}, callers.first
  end

  def test_inspect
    mod = Tracer::Module.new(:foo, :bar, :baz)

    assert_equal 'Tracer(foo, bar, baz)', mod.inspect
  end
end
