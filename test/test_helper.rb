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

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

module TraceMethodTests
  class TestCase < Minitest::Test
  end
end

Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each { |file| require file }
