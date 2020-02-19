# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'trace_method'
require 'pry'

require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/reporters'
require 'mutant/minitest/coverage'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }

module TraceMethodTests
  class TestCase < Minitest::Test
    def self.inherited(descendant)
      test_name = descendant.name
      covered_class = test_name.delete_suffix('Test')

      if defined?(covered_class)
        descendant.cover covered_class
      else
        warn "#{test_name} is misnamed because #{covered_class} does not exist"
      end

      super
    end
  end
end
