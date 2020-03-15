# frozen_string_literal: true

require 'test_helper'

class TraceMethod::Adapters::BaseTest < TraceMethodTests::TestCase
  def test_that_you_cannot_fetch_callers_on_the_base_class
    assert_raises_with_message NotImplementedError, message: 'TraceMethod::Adapters::Base is a base class that you must inherit to use' do
      TraceMethod::Adapters::Base.new.callers 'MyAwesome::Class', 'foo'
    end
  end

  def test_that_you_cannot_fetch_traces_on_the_base_class
    assert_raises_with_message NotImplementedError, message: 'TraceMethod::Adapters::Base is a base class that you must inherit to use' do
      TraceMethod::Adapters::Base.new.traces 'MyAwesome::Class'
    end
  end

  def test_that_you_cannot_traced_callers_on_the_base_class
    assert_raises_with_message NotImplementedError, message: 'TraceMethod::Adapters::Base is a base class that you must inherit to use' do
      TraceMethod::Adapters::Base.new.traced_callers 'MyAwesome::Class'
    end
  end

  def test_that_you_cannot_add_caller_on_the_base_class
    assert_raises_with_message NotImplementedError, message: 'TraceMethod::Adapters::Base is a base class that you must inherit to use' do
      TraceMethod::Adapters::Base.new.add_caller 'MyAwesome::Class', 'foo', 'line'
    end
  end

  def test_that_you_cannot_clear_on_the_base_class
    assert_raises_with_message NotImplementedError, message: 'TraceMethod::Adapters::Base is a base class that you must inherit to use' do
      TraceMethod::Adapters::Base.new.clear
    end
  end

  def test_that_you_cannot_fetch_modules_on_the_base_class
    assert_raises_with_message NotImplementedError, message: 'TraceMethod::Adapters::Base is a base class that you must inherit to use' do
      TraceMethod::Adapters::Base.new.modules
    end
  end
end
