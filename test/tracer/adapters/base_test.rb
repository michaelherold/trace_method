# frozen_string_literal: true

require 'test_helper'

class Tracer::Adapters::BaseTest < TracerTests::TestCase
  def test_that_you_cannot_fetch_callers_on_the_base_class
    assert_raises NotImplementedError do
      Tracer::Adapters::Base.new.fetch_callers 'MyAwesome::Class', 'foo'
    rescue NotImplementedError => ex
      assert_equal 'Tracer::Adapters::Base is a base class that you must inherit to use', ex.message
      raise
    end
  end

  def test_that_you_cannot_fetch_traces_on_the_base_class
    assert_raises NotImplementedError do
      Tracer::Adapters::Base.new.fetch_traces 'MyAwesome::Class'
    rescue NotImplementedError => ex
      assert_equal 'Tracer::Adapters::Base is a base class that you must inherit to use', ex.message
      raise
    end
  end

  def test_that_you_cannot_fetch_traced_callers_on_the_base_class
    assert_raises NotImplementedError do
      Tracer::Adapters::Base.new.fetch_traced_callers 'MyAwesome::Class'
    rescue NotImplementedError => ex
      assert_equal 'Tracer::Adapters::Base is a base class that you must inherit to use', ex.message
      raise
    end
  end

  def test_that_you_cannot_store_on_the_base_class
    assert_raises NotImplementedError do
      Tracer::Adapters::Base.new.store_caller 'MyAwesome::Class', 'foo', 'line'
    rescue NotImplementedError => ex
      assert_equal 'Tracer::Adapters::Base is a base class that you must inherit to use', ex.message
      raise
    end
  end

  def test_that_you_cannot_clear_on_the_base_class
    assert_raises NotImplementedError do
      Tracer::Adapters::Base.new.clear
    rescue NotImplementedError => ex
      assert_equal 'Tracer::Adapters::Base is a base class that you must inherit to use', ex.message
      raise
    end
  end
end
