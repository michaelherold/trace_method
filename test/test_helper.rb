if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'tracer'
require 'pry'

require 'minitest/autorun'
require 'mutant/minitest/coverage'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }
