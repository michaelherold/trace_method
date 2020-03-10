# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-inch'
  gem 'guard-minitest'
  gem 'guard-rubocop'
  gem 'guard-yard'
  gem 'inch'
  gem 'mutant-minitest'
  gem 'rubocop'
  gem 'yard', '~> 0.9'
  gem 'yardstick'

  group :test do
    gem 'fakeredis'
    gem 'pry'
    gem 'pry-byebug', platforms: %i[mri mingw x64_mingw]
    gem 'rake'
    gem 'redis'
  end
end

group :test do
  gem 'danger-changelog', require: false
  gem 'danger-commit_lint', require: false
  gem 'danger-rubocop', require: false
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'simplecov', require: false
  gem 'timecop'
end
