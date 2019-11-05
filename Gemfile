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
  gem 'redcarpet'
  gem 'rubocop'
  gem 'yard', '~> 0.9'
  gem 'yardstick'

  group :test do
    gem 'pry-byebug'
    gem 'rake'
  end
end

group :test do
  gem 'danger-changelog', require: false
  gem 'danger-commit_lint', require: false
  gem 'danger-rubocop', require: false
  gem 'minitest'
  gem 'simplecov', require: false
end
