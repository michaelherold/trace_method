require 'test_helper'

class TracerTest < Minitest::Test
  cover 'Tracer::VERSION'

  def test_that_it_has_a_version_number
    refute_nil ::Tracer::VERSION
  end
end
