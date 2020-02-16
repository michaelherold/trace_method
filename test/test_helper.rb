# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'tracer'
require 'pry'

require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/reporters'
require 'mutant/minitest/coverage'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }
