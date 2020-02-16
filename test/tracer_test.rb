# frozen_string_literal: true

require 'test_helper'

class TracerTest < Minitest::Test
  cover 'Tracer'

  def test_that_it_has_a_version_number
    refute_nil ::Tracer::VERSION
  end

  def test_that_it_can_be_configured
    Tracer.configure do |config|
      config.adapter = 'foo'
    end

    assert_equal 'foo', Tracer.config.adapter
  end
end
