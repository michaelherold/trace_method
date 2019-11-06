require 'test_helper'

class Tracer::Adapters::RedisTest < Minitest::Test
  cover 'Tracer::Adapters::Redis'

  def setup
    @adapter = Tracer::Adapters::Redis.new(url: 'redis://localhost:5379/1')
  end

  def test_that_it_can_store_and_fetch_callers_and_traces
    mod = 'MyModule::IsAwesome'
    line = "/opt/ruby/.gem/ruby/2.6.3/gems/pry-0.12.2/lib/pry/pry_instance.rb:272"

    @adapter.store_caller mod, 'foo', line

    assert_equal ['foo'], @adapter.fetch_traces(mod)
    assert_equal [line], @adapter.fetch_callers(mod, 'foo')
  end
end
