# frozen_string_literal: true

module Minitest
  module Assertions
    def assert_raises_with_message(*expected, message:)
      checked_message = false

      assert_raises(*expected) do
        yield
      rescue *expected => e
        assert_equal message, e.message
        checked_message = true
        raise
      end

      assert checked_message, 'The error was not raised to check its message'
    end
  end
end
