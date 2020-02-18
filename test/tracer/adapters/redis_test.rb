# frozen_string_literal: true

require 'test_helper'

class Tracer::Adapters::RedisTest < TracerTests::TestCase
  def setup
    @adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
  end

  def test_that_it_can_store_and_fetch_callers_and_traces
    mod = 'MyModule::IsAwesome'
    line = '/opt/ruby/.gem/ruby/2.6.3/gems/pry-0.12.2/lib/pry/pry_instance.rb:272'

    @adapter.store_caller mod, 'foo', line

    assert_equal ['foo'], @adapter.fetch_traces(mod)
    assert_equal [line], @adapter.fetch_callers(mod, 'foo')
    assert_equal({ 'foo' => [line] }, @adapter.fetch_traced_callers(mod))
  end

  def test_that_it_can_clear_stored_data
    mod = 'This::Test'
    line = '/path/to/this/test.rb:9001'

    @adapter.store_caller mod, 'foo', line
    @adapter.clear

    assert_equal [], @adapter.fetch_traces(mod)
    assert_equal [], @adapter.fetch_callers(mod, 'foo')
    assert_equal({}, @adapter.fetch_traced_callers(mod))
  end
end
