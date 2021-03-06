# frozen_string_literal: true

require 'test_helper'

class TraceMethod::Adapters::RedisTest < TraceMethodTests::TestCase
  def test_that_it_can_store_and_fetch_callers_and_traces
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    mod = 'MyModule::IsAwesome'
    line = '/opt/ruby/.gem/ruby/2.6.3/gems/pry-0.12.2/lib/pry/pry_instance.rb:272'

    adapter.add_caller mod, 'foo', line

    assert_equal ['foo'], adapter.traces(mod)
    assert_equal [line], adapter.callers(mod, 'foo')
    assert_equal({ 'foo' => [line] }, adapter.traced_callers(mod))
    assert_equal ['MyModule::IsAwesome'], adapter.modules
  end

  def test_that_it_can_clear_stored_data
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    mod = 'This::Test'
    line = '/path/to/this/test.rb:9001'

    adapter.add_caller mod, 'foo', line
    adapter.clear

    assert_equal [], adapter.traces(mod)
    assert_equal [], adapter.callers(mod, 'foo')
    assert_equal({}, adapter.traced_callers(mod))
    assert_equal [], adapter.modules
  end

  def test_that_it_sets_expiries_on_used_keys
    adapter = TraceMethod::Adapters::Redis.new(url: 'redis://localhost:5379/1')
    mod = 'MyModule::IsAwesome'
    line = '/opt/ruby/.gem/ruby/2.6.3/gems/pry-0.12.2/lib/pry/pry_instance.rb:272'

    Timecop.freeze(Time.now) do
      adapter.add_caller mod, 'foo', line

      Timecop.freeze(Time.now + adapter.expiry - 1) do
        assert_equal ['foo'], adapter.traces(mod)
        assert_equal [line], adapter.callers(mod, 'foo')
        assert_equal({ 'foo' => [line] }, adapter.traced_callers(mod))
        assert_equal ['MyModule::IsAwesome'], adapter.modules
      end

      Timecop.freeze(Time.now + adapter.expiry) do
        assert_equal [], adapter.traces(mod)
        assert_equal [], adapter.callers(mod, 'foo')
        assert_equal({}, adapter.traced_callers(mod))
        assert_equal [], adapter.modules
      end
    end
  end
end
