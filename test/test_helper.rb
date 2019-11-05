if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'tracer'

require 'minitest/autorun'
require 'mutant/minitest/coverage'
