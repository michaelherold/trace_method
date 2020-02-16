# frozen_string_literal: true

require 'test_helper'

class Tracer::Adapters::BaseTest < Minitest::Test
  cover 'Tracer::Adapters::Base'

  def test_that_you_cannot_fetch_callers_on_the_base_class
    assert_raises NotImplementedError, 'Tracer::Adapters::Base is a base class that you must inherit to use' do
      Tracer::Adapters::Base.new.fetch_callers 'MyAwesome::Class', 'foo'
    end
  end

  def test_that_you_cannot_fetch_traces_on_the_base_class
    assert_raises NotImplementedError, 'Tracer::Adapters::Base is a base class that you must inherit to use' do
      Tracer::Adapters::Base.new.fetch_traces 'MyAwesome::Class'
    end
  end

  def test_that_you_cannot_fetch_traced_callers_on_the_base_class
    assert_raises NotImplementedError, 'Tracer::Adapters::Base is a base class that you must inherit to use' do
      Tracer::Adapters::Base.new.fetch_traced_callers 'MyAwesome::Class'
    end
  end

  def test_that_you_cannot_store_on_the_base_class
    assert_raises NotImplementedError, 'Tracer::Adapters::Base is a base class that you must inherit to use' do
      Tracer::Adapters::Base.new.store_caller 'MyAwesome::Class', 'foo', 'line'
    end
  end
end
